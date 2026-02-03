# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Google's UI toolkit for building beautiful, natively compiled applications"
HOMEPAGE="https://flutter.dev"

MY_PV="${PV}-stable"
SRC_URI="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${MY_PV}.tar.xz -> ${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Runtime dependencies based on typical Linux flutter requirements
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

src_install() {
	# Install the entire directory to /opt/flutter
	insinto /opt/flutter
	doins -r .

	# Fix permissions for binaries
	fperms +x /opt/flutter/bin/flutter
	fperms +x /opt/flutter/bin/dart
	fperms +x /opt/flutter/bin/internal/shared.sh
	
	# Symlink binaries to /usr/bin
	dosym ../../opt/flutter/bin/flutter /usr/bin/flutter
	dosym ../../opt/flutter/bin/dart /usr/bin/dart
}
