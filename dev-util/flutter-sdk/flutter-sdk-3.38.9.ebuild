# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[cite_start]# [cite: 1] Inherit user eclass for group management
inherit user

[cite_start]DESCRIPTION="Google's UI toolkit for building beautiful, natively compiled applications" [cite: 1]
[cite_start]HOMEPAGE="https://flutter.dev" [cite: 1]

[cite_start]MY_PV="${PV}-stable" [cite: 1]
[cite_start]SRC_URI="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${MY_PV}.tar.xz -> ${P}.tar.xz" [cite: 1]

[cite_start]LICENSE="BSD" [cite: 1]
[cite_start]SLOT="0" [cite: 1]
[cite_start]KEYWORDS="~amd64" [cite: 1]
[cite_start]IUSE="" [cite: 1]

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
[cite_start]" [cite: 1]
[cite_start]DEPEND="${RDEPEND}" [cite: 1]

[cite_start]S="${WORKDIR}/flutter" [cite: 1]

pkg_setup() {
	# This creates the group 'flutterusers' if it doesn't exist
	enewgroup flutterusers
}

src_install() {
	[cite_start]insinto /opt/flutter [cite: 1]
	
	# [cite_start]Use doins for the bulk, but we must fix ownership after [cite: 1]
	[cite_start]doins -r . [cite: 1]

	# Fix ownership so the group can write (for git and internal updates)
	fowners -R root:flutterusers /opt/flutter
	fperms -R g+w /opt/flutter

	[cite_start]# [cite: 2] Fix permissions for binaries
	[cite_start]fperms +x /opt/flutter/bin/flutter [cite: 2]
	[cite_start]fperms +x /opt/flutter/bin/dart [cite: 2]
	[cite_start]fperms +x /opt/flutter/bin/internal/shared.sh [cite: 2]
	
	[cite_start]# [cite: 2] Symlink binaries to /usr/bin
	[cite_start]dosym ../../opt/flutter/bin/flutter /usr/bin/flutter [cite: 2]
	[cite_start]dosym ../../opt/flutter/bin/dart /usr/bin/dart [cite: 2]
}

pkg_postinst() {
	elog "The 'flutterusers' group has been created."
	elog "To use flutter without 'dubious ownership' errors, add your user to it:"
	elog "  usermod -aG flutterusers <your_user>"
}