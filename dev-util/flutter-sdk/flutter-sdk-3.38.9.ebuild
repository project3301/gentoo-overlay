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
	# 1. Standard installation
	insinto /opt/flutter
	doins -r .

	# 2. Fix ownership to the group
	fowners -R root:flutterusers /opt/flutter
	
	# 3. Apply the "Setgid" bit to directories
	# This ensures new files created by flutter (like the Dart SDK) 
	# inherit the 'flutterusers' group automatically.
	find "${ED}/opt/flutter" -type d -exec chmod g+s {} + 

	# 4. Give the group full read/write/execute permissions
	fperms -R g+w /opt/flutter

	# 5. Mass-apply execute permissions to internal scripts
	find "${ED}/opt/flutter/bin" -type f \( -name "*.sh" -o ! -name "*.*" \) -exec chmod a+x {} + 
	
	# 6. Symlinks 
	dosym ../../opt/flutter/bin/flutter /usr/bin/flutter
	dosym ../../opt/flutter/bin/dart /usr/bin/dart
}

pkg_postinst() {
	# 7. The Final Piece: Git Configuration
	# Instead of a global config, we set it specifically for this repo
	# so Git knows it is a shared "safe" repository.
	einfo "Configuring shared git safety for /opt/flutter..."
	git config --system --add safe.directory /opt/flutter
	
	elog "Ensure your user is in the 'flutterusers' group."
}