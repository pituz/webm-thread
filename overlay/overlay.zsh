#!/usr/bin/env zsh
source ~/.zshrc.avenc
iargs=()
oargs=()
while getopts "s:t:n" o; do
    case $o in
        s) iargs=(-ss $OPTARG) ;;
        t) oargs=(-t $OPTARG); length=$OPTARG;;
	n) nofirstframe=1
    esac
done
shift $((OPTIND-1))
[[ -z $length ]] && length=$(ffprobe $1 2>&1|sed -n 's/.*Duration: \([^,]\+\),.*/\1/p')
for pass in 1 2
    ffmpeg -hide_banner $iargs -i $1 \
        -i thread-tv-clean-19_33-571:350.png \
        $oargs \
        -filter_complex '
            [0:v] scale=552:317 [v0],
            [v0] pad=600:446:20:35:black [v1],
            [v1] [1:v] overlay [v2]' \
        -map '[v2]' -map '0:a' -ac 2 -crf 20 -b:v $(hkbr $length)  -pass $pass -y "$(basename $1)-overlay-v.webm" || exit 1
if ! ((nofirstframe))
then
    mkvmerge thread-firstframe.webm + "$(basename $1)-overlay-v.webm" -o "$(basename $1)-overlay.webm" || exit 1
    rm "$(basename $1)-overlay-v.webm"
fi
