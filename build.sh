#!/bin/bash
#
# This purpose of this script is to build working *executables* of various
# SWF-related projects. If you are interested in extras (docs, plugins,
# tests, etc.) you will have to build them manually for each project.
#
# Each project checks out a commit id that is known to compile. This may not be
# the most up-to-date version of the code. Deleting the 7-char commit id will
# cause git to checkout the most recent version of the code.
#
# The build system is simple, but in-efficient; libraries may be built multiple
# times during a single build.


# Exit on error.
set -e

# Error handler. Prints command which caused error. (Line number may be wrong.)
trap 'echo Failed on line: ${LINENO} at command: ${BASH_COMMAND} && exit $?' ERR


PWD=`pwd`
SUPPORT_DIR=${PWD}/support
BUILD_DIR=${PWD}/bld
INST_DIR=${PWD}/inst
DIST_DIR=${PWD}/floshen_dist
BRANCH_PFX=floshen


# Define install dir. This property will be supplied to all Autoconf projects.
ACONF_PFX="--prefix=${INST_DIR}"

# Set to 'on' to enable, anything else disables. Dev mode enables extra actions.
DEV_MODE=off







# Return the git branch name
is_git_branch_name() {
    local CUR_BRANCH_NAME=`git rev-parse --abbrev-ref HEAD`
    test "x${CUR_BRANCH_NAME}" = "x$1"
}

 


 

 
 
 

#################################
##
##    GNASH
##
#################################
tgt_gnash_bld() {
    local BRANCH_NAME=${BRANCH_PFX}-bld

    if [ ! -e gnash ]; then
        git clone https://git.savannah.gnu.org/git/gnash.git
    fi

    cd ./gnash
        if is_git_branch_name "master"; then
            # Revert changes && delete target branch if it exists
            (git checkout . && (git branch --delete --force ${BRANCH_NAME} || true)) &> /dev/null
            # Checkout commit id: 583ccbc1275c7701dc4843ec12142ff86bb305b4
            git checkout 583ccbc -b ${BRANCH_NAME}
            git apply ${SUPPORT_DIR}/gnash/gnash00.diff
        fi

        export PKG_CONFIG_PATH=${INST_DIR}/lib/pkgconfig
        ./autogen.sh
        # Avoid need for xulrunner package with '--disable-npapi'.
        ./configure  --disable-npapi ${ACONF_PFX}
        make
    cd ..
}

tgt_gnash_inst() {
    cd gnash
        make install
    cd ..
}





#################################
##
##    LIBMING
##
#################################
tgt_libming_bld() {
    local BRANCH_NAME=${BRANCH_PFX}-ming-0.4.8

    if [ ! -e libming ]; then
        git clone https://github.com/libming/libming.git
        if is_git_branch_name "master"; then
            # Revert changes && delete target branch if it exists
            (git checkout . && (git branch --delete --force ${BRANCH_NAME} || true)) &> /dev/null
            git checkout tags/ming-0_4_8 -b ${BRANCH_NAME}
        fi
    fi

    cd ./libming
        ./autogen.sh
        ./configure ${ACONF_PFX}
        make
    cd ..
}

tgt_libming_inst() {
    cd libming
        make install
    cd ..
}





#################################
##
##    LIBOIL
##
#################################
tgt_liboil_bld() {
    if [ ! -e ./liboil-0.3.17 ]; then
        tar -xzf ${SUPPORT_DIR}/liboil/liboil-0.3.17.tar.gz
    fi

    cd liboil-0.3.17
        ./autogen.sh --disable-gtk-doc ${ACONF_PFX}
        make
    cd ..
}

tgt_liboil_inst() {
    cd liboil-0.3.17
        make install
    cd ..
}





#################################
##
##    LIBGSTPLUGINSBASE
##
#################################
tgt_libgstpluginsbase_bld() {
    local BRANCH_NAME=${BRANCH_PFX}-gst-0.10

    if [ ! -e gst-plugins-base ]; then
        git clone https://gitlab.freedesktop.org/gstreamer/gstreamer.git gst-plugins-base
    fi

    export PKG_CONFIG_PATH=${INST_DIR}/lib/pkgconfig
    cd gst-plugins-base
        if is_git_branch_name "main"; then
            # Revert changes && delete target branch if it exists
            (git checkout . && (git branch --delete --force ${BRANCH_NAME} || true)) &> /dev/null
            git checkout tags/gst-plugins-base-0.10.36 -b ${BRANCH_NAME}
        fi

        ./autogen.sh --disable-gtk-doc ${ACONF_PFX}
        make
    cd ..
}

tgt_libgstpluginsbase_inst() {
    cd gst-plugins-base
        make install
    cd ..
}





#################################
##
##    LIBGSTREAMER
##
#################################
tgt_libgstreamer_bld() {
    local BRANCH_NAME=${BRANCH_PFX}-rel-0.10

    if [ ! -e gstreamer ]; then
        git clone https://gitlab.freedesktop.org/gstreamer/gstreamer.git
    fi
 
    cd gstreamer
        if is_git_branch_name "main"; then
            # Revert changes && delete target branch if it exists
            (git checkout . && (git branch --delete --force ${BRANCH_NAME} || true)) &> /dev/null
            git checkout tags/RELEASE-0.10.36 -b ${BRANCH_NAME}
            git apply ${SUPPORT_DIR}/gstreamer/gstreamer00.diff
        fi
        ./autogen.sh --disable-gtk-doc ${ACONF_PFX}
        make
    cd ..
}

tgt_libgstreamer_inst() {
    cd gstreamer
        make install
    cd ..
}





#################################
##
##    LIGHTSPARK
##
#################################
tgt_lightspark_bld() {
    local BRANCH_NAME=${BRANCH_PFX}-bld

    if [ ! -e ./lightspark ]; then
        git clone https://github.com/lightspark/lightspark.git
    fi

    cd ./lightspark
        if is_git_branch_name "master"; then
            # Revert changes && delete target branch if it exists
            (git checkout . && (git branch --delete --force ${BRANCH_NAME} || true)) &> /dev/null
            # Checkout commit id: 7c71a588db17c06e179f25717ac0f98c56c487a4
            git checkout 7c71a58 -b ${BRANCH_NAME}
        fi

        # This build recipe was taken from build.sh of lightspark
        mkdir -p obj-release
        cd obj-release
            cmake -DCMAKE_BUILD_TYPE=Release ..
            make -j $(grep -c processor /proc/cpuinfo)
        cd ..
    cd ..
}

tgt_lightspark_inst() {
    mkdir -p ${INST_DIR}/bin
    mkdir -p ${INST_DIR}/lib
    cd lightspark
        if [ -e ./obj-release/x86_64/Release ]; then
            echo "Installing lightspark files to ${INST_DIR}"
            cp    ./obj-release/x86_64/Release/bin/* ${INST_DIR}/bin/
            cp -a ./obj-release/x86_64/Release/lib/* ${INST_DIR}/lib/

            # Copy script for running software renderer.
            cp ${SUPPORT_DIR}/lightspark/lightspark-sw ${INST_DIR}/bin/
            chmod +x ${INST_DIR}/bin/lightspark-sw
        else
            echo "Release directory not found. Nothing to do."
        fi
    cd ..
}





#################################
##
##    RUFFLE
##
#################################
tgt_ruffle_bld() {
    local BRANCH_NAME=${BRANCH_PFX}-bld

    if [ ! -e ruffle ]; then
        git clone https://github.com/ruffle-rs/ruffle.git
        if is_git_branch_name "master"; then
            # Revert changes && delete target branch if it exists
            (git checkout . && (git branch --delete --force ${BRANCH_NAME} || true)) &> /dev/null
            # Checkout commit id: 74ab24c0c3345025a1b7297c526c37783ecc9990
            git checkout 74ab24c -b ${BRANCH_NAME}
        fi
    fi

    # Ensure we can run the Rust toolchain
    if ! cargo --version 2> /dev/null; then
        if [ ! -e $HOME/.cargo/env ]; then
            # Install Rust toolchain, per https://rustup.rs/ (prompts user)
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        fi
        source $HOME/.cargo/env  # Created by rustup installer
    fi

    cd ruffle
        cargo build --package=ruffle_desktop
    cd ..
}

tgt_ruffle_inst() {
    mkdir -p ${INST_DIR}/bin
    cd ruffle
        if [ -e ./target/debug/ruffle_desktop ]; then
            echo "Installing ruffle to ${INST_DIR}"
            cp ./target/debug/ruffle_desktop ${INST_DIR}/bin
        else
            echo "Nothing to do."
        fi
    cd ..
}





#################################
##
##    SWFDEC
##
#################################
tgt_swfdec_bld() {
    local BRANCH_NAME=${BRANCH_PFX}-bld

    if [ ! -e swfdec ]; then
        git clone https://github.com/mltframework/swfdec.git
    fi

    # export PKG_CONFIG_PATH=$DDIR/liboil-0.3.17:$DDIR/libming/src
    export PKG_CONFIG_PATH=${INST_DIR}/lib/pkgconfig
    cd ./swfdec
        if is_git_branch_name "master"; then
            # Revert changes && delete target branch if it exists
            (git checkout . && (git branch --delete --force ${BRANCH_NAME} || true)) &> /dev/null
            # Checkout commit id; de1eef41a1360a15bcc1b46a9ca5b9db0606e06c
            git checkout de1eef4 -b ${BRANCH_NAME}
            git apply ${SUPPORT_DIR}/swfdec/swfdec00.patch
        fi

        autoreconf -i -f   # Copied from autogen.sh of swfdec
        ./configure ${ACONF_PFX}
        make
    cd ..
}

tgt_swfdec_inst() {
    cd ./swfdec
        make install
        # Copy additional binaries. Rename to avoid any conflicts.
        cp ./player/.libs/swfplay       ${INST_DIR}/bin/swfdec-play
        cp ./tools/.libs/swfdec-extract ${INST_DIR}/bin/
        cp ./tools/.libs/dump           ${INST_DIR}/bin/swfdec-dump
    cd ..
}





#################################
##
##    SWFTOOLS
##
#################################
tgt_swftools_bld() {
    local BRANCH_NAME=${BRANCH_PFX}-bld

    if [ ! -e ./swftools ]; then
        git clone http://github.com/matthiaskramm/swftools.git
    fi

    cd swftools
        if is_git_branch_name "master"; then
            # Revert changes && delete target branch if it exists
            (git checkout . && (git branch --delete --force ${BRANCH_NAME} || true )) &> /dev/null
            # Checkout commit id; 772e55a271f66818b06c6e8c9b839befa51248f4
            git checkout 772e55a -b ${BRANCH_NAME}
        fi
        ./configure ${ACONF_PFX}

        # Sometimes the first run of 'make' fails with:
        #    "No rule to make target 'xpdf/TextOutputDev.o ..."
        # See: https://github.com/matthiaskramm/swftools/issues/12
        # As a work-around, run twice, ignoring the result of the first run.
        (make || make)
  cd ..
}

tgt_swftools_inst() {
    cd swftools
        make install
    cd ..
}


















# Convenience functions to build and auto-install all pre-requisites of the
# specified program. These also build and auto-install the actual program.

cp_support_files() {
    # Copy env script
    cp ${SUPPORT_DIR}/extra/set-floshen-env ${INST_DIR}

    # Copy vid2swf.sh
    cp ${SUPPORT_DIR}/extra/vid2swf.sh ${INST_DIR}/bin/
    chmod +x ${INST_DIR}/bin/vid2swf.sh

    # Copy lightspark-sw
    if [ -e ${INST_DIR}/bin/lightspark ]; then
        cp ${SUPPORT_DIR}/lightspark/lightspark-sw ${INST_DIR}/bin/
    fi
}

build_gnash() {
    tgt_libgstreamer_bld
    tgt_libgstreamer_inst
    tgt_libgstpluginsbase_bld
    tgt_libgstpluginsbase_inst
    tgt_gnash_bld
    tgt_gnash_inst
    cp_support_files
}

build_libming() {
    tgt_libming_bld
    tgt_libming_inst
    cp_support_files
}

build_lightspark() {
    tgt_lightspark_bld
    tgt_lightspark_inst
    cp_support_files
}

build_ruffle() {
    tgt_ruffle_bld
    tgt_ruffle_inst
    cp_support_files
}

build_swfdec() {
    tgt_libgstreamer_bld
    tgt_libgstreamer_inst
    tgt_libgstpluginsbase_bld
    tgt_libgstpluginsbase_inst
    tgt_liboil_bld
    tgt_liboil_inst
    tgt_swfdec_bld
    tgt_swfdec_inst
    cp_support_files
}

build_swftools() {
    tgt_swftools_bld
    tgt_swftools_inst
    cp_support_files
}








# Convenience functions.

# Build all projects, except ruffle.
do_most() {
    build_gnash
    build_libming
    build_lightspark
    build_swfdec
    build_swftools
}

# Build all projects. (Build 'ruffle' first in order to immediately answer
# confirmation prompt by rustup installer.)
do_all() {
    build_ruffle
    build_most
}








# Helper functions for do_dist().

cp_bin_files() {
    for fil in $@; do
        if [ -e ${INST_DIR}/bin/$fil ]; then
            cp ${INST_DIR}/bin/$fil ${DIST_DIR}/bin/
        fi
    done
}

is_elf_binary() {
    $(file --brief $1 | cut -d' ' -f 1 | grep --quiet "ELF")
    return $?
}

cp_lib_files() {
    local LIB_PILE=_tmp_pile.txt
    rm -f ${LIB_PILE}

    # Collect all libs
    for fil in `ls ${DIST_DIR}/bin`; do
        if is_elf_binary ${DIST_DIR}/bin/$fil; then
            ldd ${DIST_DIR}/bin/$fil | cut -d' ' -f 1 >> ${LIB_PILE}
        fi
    done
    
    # Find subdirs of './lib'.
    local LIBDIRS=`find ${INST_DIR}/lib -type d`

    # Copy libs.
    for libname in `sort ${LIB_PILE} | uniq`; do
        for libdir in ${LIBDIRS}; do
            if [ -e ${libdir}/$libname ]; then
                cp ${libdir}/$libname ${DIST_DIR}/lib/
                break
            fi
        done
    done

    # clean up
    rm -f ${LIB_PILE}
}

# Copies select files, strips binaries and libs, creates '.tar.gz' file.
do_dist() {
    if [ -e ${INST_DIR} ]; then
        mkdir -p ${INST_DIR}/lib # Ensure dir exists
        
        rm -rf ${DIST_DIR}
        mkdir -p ${DIST_DIR}/bin
        mkdir -p ${DIST_DIR}/lib

        cp ${INST_DIR}/set-floshen-env ${DIST_DIR}
        #cp ${INST_DIR}/bin/vid2swf.sh ${DIST_DIR}/bin/

        cd ${DIST_DIR}


            echo "Copying files..."
            # Files will exist only if project was built.

            # gnash
            cp_bin_files dump-gnash fb-gnash gnash gtk-gnash sdl-gnash

            # lightspark 
            cp_bin_files lightspark lightspark-sw

            # ruffle
            cp_bin_files ruffle_desktop

            # swfdec
            cp_bin_files swfdec-extract swfdec-dump swfdec-play

            # swftools
            cp_bin_files as3compile font2swf gif2swf jpeg2swf pdf2swf png2swf swfbbox swfc swfcombine swfdump swfextract swfrender swfstrings wav2swf

            # libming
            cp_bin_files gif2dbl gif2mask listaction listfdb listjpeg listmp3 listswf makefdb makeswf png2dbl   raw2adpcm  swftocxx swftoperl swftophp swftopython swftotcl

            # misc
            cp_bin_files vid2swf.sh

            # Copy libs required by binary files
            cp_lib_files

            echo "Stripping files..."
            for nm in `ls ${DIST_DIR}/bin/`; do
                fil=${DIST_DIR}/bin/$nm
                if is_elf_binary $fil; then
                    strip --strip-all $fil
                fi
            done
            find ./lib -type f -executable -exec strip --strip-all {} \;
            
        cd ..

        echo "Bundling files..."
        local DDIR=$(basename ${DIST_DIR})
        local TAR_NAM=${DDIR}.tar
        local GZ_NAM=${TAR_NAM}.gz
        local XZ_NAM=${TAR_NAM}.xz
        rm -f ${TAR_NAM}
        rm -f ${GZ_NAM}
        rm -f ${XZ_NAM}

        tar cf ${TAR_NAM} -C ${PWD} ${DDIR}
        echo "Compressing bundle..."
        gzip -c -9 ${TAR_NAM} > ${GZ_NAM}
        echo "  Created ${GZ_NAM}"
        xz   -c -9 ${TAR_NAM} > ${XZ_NAM}
        echo "  Created ${XZ_NAM}"
        rm ${TAR_NAM}
        rm -rf ${DIST_DIR}
        echo "Done"
    else
        echo "Install directory ${INST_DIR} does not exist."
    fi
}










show_help() {
    echo "Build SWF-related programs."
    echo "Usage: $0 NAME"
    echo "       $0 most | all | dist"
    echo ""
    echo "  NAME          Build the app specified by NAME"
    echo "  most          Build all apps, except 'ruffle'"
    echo "  all           Build all apps"
    echo "  dist          Create distribution from the install directory"
    echo ""
    echo " NAME is one of: gnash, libming, lightspark, ruffle, swfdec, swftools"

    if [ "x${DEV_MODE}" = "xon" ]; then
        echo ""
        echo "========== Begin Dev Mode options ========="
        echo ""
        echo "Usage: $0 TGT [ inst ]"
        echo ""
        echo "  TGT       Qne of:"
        echo "                 gnash_"
        echo "                 libgstpluginsbase_"
        echo "                 libgstreamer_"
        echo "                 lightspark_"
        echo "                 libming_"
        echo "                 liboil_"
        echo "                 ruffle_"
        echo "                 swfdec_"
        echo "                 swftools_"
        echo ""
        echo "  inst      If not present, builds TARGET; if present, installs (but"
        echo "            does not build) TARGET to ${INST_DIR}"
        echo ""
        echo "========== End Dev Mode options ========="
    fi

    echo ""
    echo "  gnash      - SWF player."
    echo "  libming    - Library to read/write SWF files; includes a SWF compiler; has"
    echo "               bindings for C, C++, Java, Perl, PHP, Python, Ruby, TCL."
    echo "  lightspark - SWF player. Uses OpenGL by default, but is not required."
    echo "  ruffle     - SWF player. REQUIRES accelerated video hardware (e.g. DirectX"
    echo "               11/12, Metal, Vulkan). OpenGL is not well supported."
    echo "  swfdec     - Library for decoding SWF files; includes a player."
    echo "  swftools   - Tools to manipulate SWF files; includes a SWF compiler."
    echo ""
    echo "The apps will be auto-installed in '${INST_DIR}'."
    echo "To uninstall, delete the directory."
    echo ""
    echo "The Ruffle project (https://ruffle.rs/) provides pre-built, static binaries. If"
    echo "your glibc is compatible, you may wish to try one of them instead of building"
    echo "with this script. Building Ruffle requires a Rust toolchain. If one is not"
    echo "present this script will install one using 'rustup' (https://rustup.rs/). Rustup"
    echo "requires user-confirmation before proceeding. To remove the toolchain, run"
    echo "'rustup self uninstall'. Building the Ruffle app takes about 4.5 Gb of space."
    echo ""
    echo "If useful, HAXE (https://haxe.org/) is another option to generate SWF files."


}




# Select the action to perform for the app.
select_act() {
    local APP=$1
    local ACT=$2

    if [ "x${ACT}" = "x" ]; then
        ACT=bld
    fi

    case "${ACT}" in

        bld | inst)
            tgt_${APP}${ACT}  # APP will have a trailing '_'.
            ;;

        *)
            echo "Bad action" $2
            exit 1
            ;;
    esac
}


# Select the app to build.
select_app() {
    local APPL="$1"

    if [ "$#" -gt "0" ]; then
      shift
    fi

    case "$APPL" in

        most | all | dist)
            do_${APPL} $@
            ;;

        gnash | libming | lightspark | ruffle |  swfdec | swftools)
            build_${APPL} $@
            ;;

        # Extra targets for developers
        swftools_ | lightspark_ | ruffle_ | gnash_ | swfdec_ | libgstreamer_ | libgstpluginsbase_ | liboil_ | libming_)
            if [ "x${DEV_MODE}" = "xon" ]; then
                select_act ${APPL} $@
            else
                echo "Dev Mode is disabled. Edit script to enable."
            fi
            ;;

        *)
            show_help
            exit 1
            ;;
    esac
}


# If we are in the right directory, begin build.
if [ -e ./support/liboil/liboil-0.3.17.tar.gz ]; then
    mkdir -p ${BUILD_DIR}
    cd ${BUILD_DIR}
        select_app $@
    cd ..
else
    echo "Running from wrong directory. Exiting."
    exit 1
fi
