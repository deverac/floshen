**Floshen**: A script for easily building a collection of open source
SWF-related projects.

The projects include programs for playing SWF files, compiling ActionScript 2/3
source code into SWF files, and manipulating SWF files. The programs have
varying degrees of maturity and ease-of-use. Visit the website of each project
for documentation and other details.  

# Synopsis

A synopsis of the programs and their tools follow:


[**gnash**](https://www.gnu.org/software/gnash/): A SWF player. (Source code:
git://git.sv.gnu.org/gnash.git)

    dump-gnash        Dump an SWF file
    fb-gnash          A SWF viewer for a framebuffer
    gtk-gnash         A SWF viewer for GTK
    sdl-gnash         A SWF viewer for SDL
    gnash             A wrapper to select appropriate viewer


[**libming**](http://www.libming.org/): A library to read/write SWF files;
includes a SWF compiler; has bindings for C, C++, Java, Perl, PHP, Python,
Ruby, TCL. ([Source code](https://github.com/libming/libming))

     makeswf          Compile actionscript code into an SWF movie
     listswf          SWF format disassembler.
     listaction       Show ActionScript in the SWF.
     listfdb          Show contents of fdb font file.
     listmp3          Show frame header info in mp3 files.
     listjpeg         Show frame header info in jpeg files.
     swftoperl        Attempt to make a perl/ming script out of a SWF file.
     swftophp         Attempt to make a php/ming script out of a SWF file.
     swftopython      A todo for pythonfriends :-) not done yet.
     swftocxx         Attempt to make a cxx/ming script out of a SWF file.
     swftotcl         Attempt to make a tcl/ming script out of a SWF file.
     makefdb          Extract fdb font definition files out of a SWF file.
     png2dbl          Convert a png-file to dbl.
     gif2dbl          Convert a gif-file to dbl.
     gif2mask         Convert a gif image to an alpha mask.
     raw2adpcm        Convert a raw(pcm?) soundfile to a adpcm-coded soundfile.


[**lightspark**](https://lightspark.github.io/): A SWF player. Uses OpenGL by
default, but is not required.
([Source code](https://github.com/lightspark/lightspark))

    lightspark        A SWF player using OpenGL rendering.
    lightspark-sw     A SWF player using software rendering.


[**ruffle**](https://ruffle.rs/): A SWF player. REQUIRES accelerated video
hardware (e.g. DirectX, 11/12, Metal, Vulkan, Web GPU). OpenGL is not well
supported. ([Source code](https://github.com/ruffle-rs/ruffle))

    ruffle_desktop    A SWF player.


**swfdec**: A C-library for reading SWF files; includes a player.
([Source code](https://github.com/mltframework/swfdec))

    swfdec-extract    Extract resources from a SWF file.
    swfdec-dump       Display info from a SWF (Originally named 'dump'.)
    swfdec-play       SWF player. (Originally named 'swfplay'.)


[**swftools**](http://swftools.org/): Tools to manipulate SWF files; includes
a SWF compiler. ([Source code](https://github.com/matthiaskramm/swftools))

    as3compile        A standalone ActionScript 3.0 compiler. Mostly compatible with Flex.
    font2swf          Converts font files (TTF, Type1) to SWF.
    gif2swf           Converts GIFs to SWF. Also able to handle animated gifs.
    jpeg2swf          Takes one or more JPEG pictures and generates a SWF slideshow from them.
    pdf2swf           A PDF to SWF Converter. Generates one frame per page. Supports tables, graphics.
    swfcombine        A multi-tool to wrap, stack, concatenate, SWFs; can modify basic parameters.
    png2swf           Like JPEG2SWF, only for PNGs.
    swfbbox           Allows to read out, optimize and readjust SWF bounding boxes.
    swfc              A tool for creating SWF from script files.
    swfcombine        Combine PNGS, one per frame, into a SWF.
    swfdump           Prints SWF info, like contained images/fonts/sounds, bounding boxes.
    swfwxtract        Allows to extract Movieclips, Sounds, Images etc. from SWF files.
    swfrender         Render each frame of a SWF as a PNG.
    swfstrings        Scans SWFs for text data.
    wav2swf           Converts WAV audio files to SWFs, using the L.A.M.E. MP3 encoder library.

# Prerequisites to Building

In order to build all the projects, a large number of supporting software
packages must be installed. The packages can be installed using `apt-get`:

> \# apt-get install autoconf automake autopoint cmake flex g++ git libagg-dev libavcodec-dev libavformat-dev libbison-dev libboost-dev libboost-program-options-dev libboost-thread-dev libcurl4-openssl-dev libgconf2-dev libgif-dev libglew-dev libglib2.0-dev libgtk2.0-dev libjemalloc-dev libjpeg-dev libltdl3-dev liblzma-dev libpango1.0-dev librtmp-dev libsdl1.2-dev libsdl2-dev libsdl2-mixer-dev libsoup2.4-dev libswscale-dev libtool libxml2-dev make nasm pkg-config

If you do not want to install all the supporting software packages, but want
to build an individual project, you will have to repeatedly attempt to build the
project (e.g. `./build.sh swfdec`) and then install its missing dependencies
when the build fails. Installing some basic development software packages
(e.g. `# apt-get install autoconf automake git make pkg-config`) may be
necessary prior to building an individual project.

# Building

Once the pre-requisite software packages have been installed, building is simple.

To build a project:

    ./build.sh gnash            # Build the 'gnash' project
    ./build.sh lightspark       # Build the 'lightspark' project
    ./build.sh ruffle           # Build the 'ruffle' project
    ./build.sh swfdoc           # Build the 'swfdoc' project
    ./build.sh swftools         # Build the 'swftools' project
    ./build.sh libming          # Build the 'libming' project

For convenience, to build all projects, except `ruffle`:

    ./build.sh most

For convenience, to build all projects, including `ruffle`:

    ./build all

Building `ruffle` only builds the Ruffle desktop app; the Ruffle browser
plugins are not built. The [Ruffle website](https://ruffle.rs/) provides
pre-built browser plugins.

(Optional) Once the desired programs have been built, the `./inst` directory
can be bundled. Bundling creates a 'slimmed-down' version of the `./inst`
directory by excluding several directories, only copying select binaries, and
stripping the executable and library files. Bundling creates two files,
`floshen_dist.tar.gz` and `floshen_dist.tar.xz`, whose contents are identical.

    ./build.sh dist             # (Optional) Bundle all built programs.


# Running

When built, each program will be automatically installed in a sub-directory
named `./inst`. To use them:

    cd ./inst
    source set-floshen-env.sh   # Set up environment

    # Once environment has been setup, run any program (e.g.):

    swfc -o file.swf file.ac       # Compile a swfc script
    gnash file.swf                 # Play SWF

# Misc

The programs built by floshen are for working with ActionScript/SWF files on
the desktop. Major browsers no longer support playing Flash content. If there
is a need to run Flash content in a browser, there are four options:

1. Install a plugin (e.g. [Ruffle](https://ruffle.rs/))
1. Use a runtime interpreter (e.g. [swf2js](https://github.com/swf2js/swf2js), [swfobject](https://github.com/swfobject/swfobject))
1. Convert SWF video files to another format (e.g. [ffmpeg](http://ffmpeg.org/))
1. Recompile the source code to generate JS/HTML content (e.g. [Apache Royale](https://royale.apache.org/)).

---

Although not included here, the HAXE project (https://haxe.org/) has a compiler
that can generate SWF files. HAXE uses its own language; it does not parse
ActionScript files.
