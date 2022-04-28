#!/bin/bash

cd "$(dirname "$0")"

function conv_uml() {
    pdflatex $1-standalone.tex
    mv -f $1-standalone.pdf $1.pdf
    rm -f $1-standalone.log $1-standalone.aux
}

function conv_inkscape() {
    inkscape -A $1.pdf --export-latex $1.svg
    sed -i -e 's|{'$1'\.pdf}|{figures/'$1'.pdf}|' -e 's|\\unitlength \* \\real{\\svgscale}|\\svgscale\\unitlength|' -e 's|\\\\ }|}|' $1.pdf_tex
    mv $1.pdf_tex $1.tex
}

conv_uml python-interface
conv_uml graph-interface
conv_inkscape dl
conv_inkscape dl-sol
