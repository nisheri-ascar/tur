TERMUX_PKG_HOMEPAGE=https://github.com/yt-dlp/yt-dlp
TERMUX_PKG_DESCRIPTION="A youtube-dl fork with additional features and fixes"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux-user-repository"
TERMUX_PKG_VERSION="2023.12.30"
TERMUX_PKG_SRCURL=https://github.com/yt-dlp/yt-dlp/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2878501990f3ab6aa8eabb7346c16d4b4cbc01984372a1f0b3a6be8d260c7aff
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libexpat, openssl, python, python-brotli, python-pip, python-pycryptodomex"
TERMUX_PKG_SUGGESTS="ffmpeg"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, 'setuptools==67.8.0'"
TERMUX_PKG_PYTHON_TARGET_DEPS="mutagen, pycryptodomex, websockets, certifi, brotli"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	cp -Rf $TERMUX_PKG_SRCDIR ./

	pushd src
	make completions
	popd
}

termux_step_make() {
	:
}

termux_step_make_install() {
	# Install library
	pip install . --prefix=$TERMUX_PREFIX -vv --no-build-isolation --no-deps

	# Install completions
	install -Dm600 $TERMUX_PKG_HOSTBUILD_DIR/src/completions/bash/yt-dlp \
		-t "$TERMUX_PREFIX"/share/bash-completion/completions
	install -Dm600 $TERMUX_PKG_HOSTBUILD_DIR/src/completions/zsh/_yt-dlp \
		-t "$TERMUX_PREFIX"/share/zsh/site-functions
	install -Dm600 $TERMUX_PKG_HOSTBUILD_DIR/src/completions/fish/yt-dlp.fish \
		-t "$TERMUX_PREFIX"/share/fish/completions
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
