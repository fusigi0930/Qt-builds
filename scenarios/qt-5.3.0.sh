#!/bin/bash

#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'Qt-builds' project.
# Copyright (c) 2014 by Alexpux (alexpux@gmail.com)
# All rights reserved.
#
# Project: Qt-builds ( https://github.com/Alexpux/Qt-builds )
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# - Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the distribution.
# - Neither the name of the 'Qt-builds' nor the names of its contributors may
#     be used to endorse or promote products derived from this software
#     without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# **************************************************************************

P=qt
P_V=qt-everywhere-opensource-src-${QT_VERSION}
PKG_TYPE=".tar.xz"
PKG_SRC_FILE="${P_V}${PKG_TYPE}"
PKG_URL=(
	#"http://download.qt-project.org/development_releases/qt/5.2/5.2.0-beta1/single/$PKG_SRC_FILE"
	"http://download.qt-project.org/official_releases/qt/5.3/${QT_VERSION}/single/$PKG_SRC_FILE"
)
PKG_DEPENDS=(gperf icu fontconfig freetype libxml2 libxslt pcre perl ruby)

PKG_LNDIR=yes
PKG_LNDIR_SRC=$P_V
PKG_LNDIR_DEST=$P-$QT_VERSION-$QTDIR_PREFIX
PKG_CONFIGURE=configure.bat
PKG_MAKE=make

change_paths() {
	local _sql_include=
	local _sql_lib=
	[[ $STATIC_DEPS == no ]] && {
		_sql_include="$QTDIR/databases/firebird/include:$PREFIX/include/mariadb:$QTDIR/databases/oci/include"
		_sql_lib="$QTDIR/databases/firebird/lib:$QTDIR/databases/oci/lib"
	}
	export INCLUDE="$MINGWHOME/$HOST/include:$PREFIX/include:$PREFIX/include/libxml2:${_sql_include}"
	export LIB="$MINGWHOME/$HOST/lib:$PREFIX/lib:${_sql_lib}"
	export CPATH="$MINGWHOME/$HOST/include:$PREFIX/include:$PREFIX/include/libxml2:${_sql_include}"
	export LIBRARY_PATH="$MINGWHOME/$HOST/lib:$PREFIX/lib:${_sql_lib}"
	OLD_PATH=$PATH
	export PATH=$BUILD_DIR/$P-$QT_VERSION-$QTDIR_PREFIX/qtbase/bin:$BUILD_DIR/$P-$QT_VERSION-$QTDIR_PREFIX/qtbase/lib:$MINGW_PART_PATH:$MSYS_PART_PATH:$WINDOWS_PART_PATH
	#$BUILD_DIR/$P-$QT_VERSION-$QTDIR_PREFIX/gnuwin32/bin:
}

restore_paths() {
	unset INCLUDE
	unset LIB
	unset CPATH
	unset LIBRARY_PATH
	export PATH=$OLD_PATH
	unset OLD_PATH
}

src_download() {
	func_download
}

src_unpack() {
	func_uncompress
}

src_patch() {
	local _patches=(
		$P/5.3.x/0001-qt-5.3.0-oracle-driver-prompt.patch
		$P/5.3.x/0002-qt-5.3.0-use-fbclient-instead-of-gds32.patch
		$P/5.3.x/0003-qt-5.3.0-use-mingw-built-mysql-library.patch
		$P/5.3.x/0004-qt-5.3.0-win32-g++-mkspec-optimization.patch
		$P/5.3.x/0005-qt-5.3.0-syncqt-fix.patch
		$P/5.3.x/0006-qt-5.3.0-win_flex-replace.patch
		$P/5.3.x/0007-qt-5.3.0-win32-g-Enable-static-builds.patch
		$P/5.3.x/0008-qt-5.3.0-win32-g-Add-QMAKE_EXTENSION_IMPORTLIB-defaulting-to-.patch
		$P/5.3.x/0009-qt-5.3.0-qmlimportscanner-Ensure-the-correct-variant-is-run.patch
		$P/5.3.x/0010-qt-5.3.0-qdoc-increase-stack-size-for-win32-g-too.patch
		$P/5.3.x/0011-qt-5.3.0-win32-g++-allow-static-dbus-1.patch
		$P/5.3.x/0012-qt-5.3.0-compileTest-for-icu-after-setting-static-or-shared.patch
		$P/5.3.x/0013-qt-5.3.0-qtwebkit-enable-pkgconfig-support-for-win32-target.patch
		$P/5.3.x/0014-qt-5.3.0-fix-configure-tests.patch
		$P/5.3.x/0015-qt-5.3.0-properly-split-libraries-mingw.patch
		$P/5.3.x/0016-qt-5.3.0-win32-g++-use-qpa-genericunixfontdatabase.patch
		$P/5.3.x/0017-qt-5.3.0-fix-examples-building.patch
		#$P/5.3.x/0018-qt-5.3.0-add-angle-support.patch
		#$P/5.3.x/0019-qt-5.3.0-qtwebkit-angle-build-fix.patch
		#$P/5.3.x/0020-qt-5.3.0-use-external-angle-library.patch
		#$P/5.3.x/0021-qt-5.3.0-qtwebkit-dont-use-bundled-angle-libraries.patch
		#$P/5.3.x/0022-qt-5.3.0-qtwebkit-angle-update-for-angleproject-76985f-and-51b4a0.patch
		#$P/5.3.x/0023-qt-5.3.0-env-set-external-angle.patch
		$P/5.3.x/0024-qt-5.3.0-icu-add-U_LIB_SUFFIX_C_NAME.patch
		#$P/5.3.x/qt-5.3.0-fix-qtAddToolEnv-under-MSYS2-with-mingw32-make.patch
		#$P/5.3.x/qt-5.3.0-static-qmake-conf.patch
	)

	func_apply_patches \
		_patches[@]

	touch $UNPACK_DIR/$P_V/qtbase/.gitignore
}

src_configure() {

	[[ ! -d ${QTDIR}/databases && $STATIC_DEPS == no ]] && {
		mkdir -p ${QTDIR}/databases
		echo "---> Sync database folder... "
		rsync -av ${PATCH_DIR}/${P}/databases-${ARCHITECTURE}/ ${QTDIR}/databases/ > /dev/null
		echo "done"
	}

	pushd $UNPACK_DIR/$P_V/qtbase/mkspecs/win32-g++ > /dev/null
		[[ -f qmake.conf.patched ]] && {
			rm -f qmake.conf
			cp -f qmake.conf.patched qmake.conf
		} || {
			cp -f qmake.conf qmake.conf.patched
		}

		cat qmake.conf | sed 's|%OPTIMIZE_OPT%|'"$OPTIM"'|g' \
					| sed 's|%STATICFLAGS%|'"$STATIC_LD"'|g' > qmake.conf.tmp
		rm -f qmake.conf
		mv qmake.conf.tmp qmake.conf
	popd > /dev/null
	sed -i "/^QMAKE_LFLAGS_RPATH/s| -Wl,-rpath,||g" $UNPACK_DIR/$P_V/qtbase/mkspecs/common/gcc-base-unix.conf
	
	local _opengl
	[[ $USE_OPENGL_DESKTOP == yes ]] && {
		_opengl="-opengl desktop"
	} || {
		_opengl="-angle"
	}

	change_paths
	local _mode=shared
	[[ $STATIC_DEPS == yes ]] && {
		_mode=static
	}

	local _conf_flags=(
		-prefix $QTDIR_WIN
		-opensource
		-$_mode
		-confirm-license
		-debug-and-release
		$( [[ $STATIC_DEPS == no ]] \
			&& echo "-plugin-sql-ibase \
					 -plugin-sql-mysql \
					 -plugin-sql-psql \
					 -plugin-sql-oci \
					 -plugin-sql-odbc \
					 -no-iconv \
					 -icu \
					 -system-harfbuzz \
					 -system-freetype \
					 -system-pcre \
					 -system-zlib" \
			|| echo "-no-icu \
					 -no-iconv \
					 -qt-sql-sqlite \
					 -qt-zlib \
					 -qt-pcre" \
		)
		-fontconfig
		-openssl
		-no-dbus
		$_opengl
		-platform win32-g++
		-nomake tests
	)
	local _allconf="${_conf_flags[@]}"
	func_configure "$_allconf"

	restore_paths
}

pkg_build() {
	change_paths
	[[ $USE_OPENGL_DESKTOP == no ]] && {
		# Workaround for
		# https://bugreports.qt-project.org/browse/QTBUG-28845
		pushd $BUILD_DIR/$P-$QT_VERSION-$QTDIR_PREFIX/qtbase/src/angle/src/libGLESv2 > /dev/null
		[[ -f workaround.marker ]] && {
			echo "---> Workaround applied"
		} || {
			echo -n "---> Applying workaround..."
			qmake libGLESv2.pro
			cat Makefile.Debug | grep fxc.exe | cmd > workaround.log 2>&1
			echo " done"
			touch workaround.marker
		}
		popd > /dev/null
	} 
	
	local _make_flags=(
		${MAKE_OPTS}
	)
	local _allmake="${_make_flags[@]}"
	func_make \
		"$_allmake" \
		"building..." \
		"built"

	restore_paths
}

pkg_install() {
	change_paths
	
	local _install_flags=(
		${MAKE_OPTS}
		install
	)
	local _allinstall="${_install_flags[@]}"
	func_make \
		"$_allinstall" \
		"installing..." \
		"installed"

	install_docs

	# Workaround for build other components (qbs, qtcreator, etc)
	[[ ! -f $BUILD_DIR/$P-$QT_VERSION-$QTDIR_PREFIX/qwindows.marker && $STATIC_DEPS == yes ]] && {
		cp -f ${QTDIR}/plugins/platforms/libqwindows.a ${QTDIR}/lib/
		cp -f ${QTDIR}/plugins/platforms/libqwindowsd.a ${QTDIR}/lib/
		touch $BUILD_DIR/$P-$QT_VERSION-$QTDIR_PREFIX/qwindows.marker
	}

	# Workaround for installing empty .pc files
	[[ ! -f $BUILD_DIR/$P-$QT_VERSION-$QTDIR_PREFIX/pkgconfig.marker ]] && {
		echo -n "---> Fix pkgconfig files..."
		local _pc_files=( $(find $BUILD_DIR/$P-$QT_VERSION-$QTDIR_PREFIX -type f -name Qt5*.pc) )
		cp -f ${_pc_files[@]} ${QTDIR}/lib/pkgconfig/ > /dev/null 2>&1
		echo " done"
		touch $BUILD_DIR/$P-$QT_VERSION-$QTDIR_PREFIX/pkgconfig.marker
	}
	restore_paths
}

install_docs() {

	local _make_flags=(
		${MAKE_OPTS}
		docs
	)
	local _allmake="${_make_flags[@]}"
	func_make \
		"$_allmake" \
		"building docs..." \
		"built-docs"

	_make_flags=(
		${MAKE_OPTS}
		install_qch_docs
	)
	_allmake="${_make_flags[@]}"
	func_make \
		"$_allmake" \
		"installing docs..." \
		"installed-docs"
}