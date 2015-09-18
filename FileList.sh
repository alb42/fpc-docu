
export CURDIR=$(pwd)
export AROSUNITSPATH=$CURDIR/arosunits/src

export AROSUNITS="--css-file=$CURDIR/xml/fpdoc.css \
  --input=$AROSUNITSPATH/hardware.pas \
  --input=$AROSUNITSPATH/exec.pas     --descr=$CURDIR/xml/exec.xml \
  --input=$AROSUNITSPATH/utility.pas  --descr=$CURDIR/xml/utility.xml  \
  --input=$AROSUNITSPATH/amigados.pas --descr=$CURDIR/xml/amigados.xml \
  --input=$AROSUNITSPATH/agraphics.pas --descr=$CURDIR/xml/agraphics.xml \
  --input=$AROSUNITSPATH/intuition.pas --descr=$CURDIR/xml/intuition.xml \
  --input=$AROSUNITSPATH/layers.pas \
  --input=$AROSUNITSPATH/tagsarray.pas \
  --input=$AROSUNITSPATH/longarray.pas \
  --input=$AROSUNITSPATH/timer.pas \
  --input=$AROSUNITSPATH/inputevent.pas \
  --input=$AROSUNITSPATH/asl.pas \
  --input=$AROSUNITSPATH/clipboard.pas \
  --input=$AROSUNITSPATH/diskfont.pas    --descr=$CURDIR/xml/diskfont.xml \
  --input=$AROSUNITSPATH/gadtools.pas \
  --input=$AROSUNITSPATH/iffparse.pas \
  --input=$AROSUNITSPATH/keymap.pas \
  --input=$AROSUNITSPATH/mui.pas         --descr=$CURDIR/xml/mui.xml \
  --input=$AROSUNITSPATH/clipboard.pas \
  --input=$AROSUNITSPATH/workbench.pas   --descr=$CURDIR/xml/workbench.xml \
  --input=$AROSUNITSPATH/icon.pas        --descr=$CURDIR/xml/icon.xml"
