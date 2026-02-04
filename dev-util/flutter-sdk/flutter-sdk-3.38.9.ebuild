# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Removed 'inherit user' as it is deprecated/removed.
# 'eutils' or 'desktop' often provide helpers, but we'll use 
# the standard approach for EAPI 8.
inherit desktop

DESCRIPTION="Google's UI toolkit for building beautiful, natively compiled applications"
HOMEPAGE="https://flutter.dev"

MY_PV="${PV}-stable"
SRC_URI="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${MY_PV}.tar.xz -> ${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

[cite_start]# [cite: 1] RDEPEND based on typical Linux flutter requirements
RDEPEND="
	app-arch/unzip
	app-arch/zip
	dev-vcs/git
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/gtk+:3
	dev-libs/glib:2
	x11-libs/pango
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	media-libs/libglvnd
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/flutter"

pkg_setup() {
	# Modern way to ensure a group exists without user.eclass:
	# Check if group exists, if not, warn or create if possible.
	if ! getent group flutterusers >/dev/null; then
		# Using 'groupadd' directly is a bit 'dirty' for Gentoo but 
		# works for private overlays.
		groupadd -r flutterusers || die "Failed to create flutterusers group"
	fi
}

src_install() {
	# Install the entire directory to /opt/flutter
	insinto /opt/flutter
	doins -r .

	# Fix ownership so the group can write to everything (required for flutter/git)
	fowners -R root:flutterusers /opt/flutter
	fperms -R g+w /opt/flutter

	# Mass-apply execute permissions to all shell scripts and binaries in bin/
	# This avoids the "Permission denied" errors for internal helper scripts
	find "${ED}/opt/flutter/bin" -type f \( -name "*.sh" -o ! -name "*.*" \) -exec chmod a+x {} +

	# Specifically ensure the main entry points are executable (belt and suspenders)
	fperms +x /opt/flutter/bin/flutter
	fperms +x /opt/flutter/bin/dart
	
	# Symlink binaries to /usr/bin
	dosym ../../opt/flutter/bin/flutter /usr/bin/flutter
	dosym ../../opt/flutter/bin/dart /usr/bin/dart
}

pkg_postinst() {
	elog "To avoid 'dubious ownership' errors in git, add your user to the group:"
	elog "  sudo usermod -aG flutterusers <your_user>"
	elog "Then log out and back in."
}