#!/bin/sh
# A simple wrapper script around ffmpeg to convert a video file to SWF format.

show_help() {
    echo "Convert a video or audio file to SWF format (ffmpeg required)."
    echo "Usage: $0 FILE"
    echo ""
    echo "   FILE     Any file format that ffmpeg understands"
}

if [ "x$1" = "x" ]; then
    show_help
    exit 1
fi

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

if ffmpeg -version 2> /dev/null; then
    ffmpeg -i $1 $1.swf
else
    echo "Error: ffmpeg does not appear te be installed."
    exit 1
fi
