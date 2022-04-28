#!/bin/bash

# Translator for combining ASP and satisfiability modulo theories (SMT)
# based on the approach from Ilkka Niemelä's invited talk at LaSh'10.
#
# (c) 2011 Tomi Janhunen

#DIR=$HOME/asp+smt/working_asp+smt
DIR=$HOME/aspsmt-4-5-2011/aspsmt
TMP=$DIR/tmp
BIN=$DIR/bin
DEF=$DIR/def

# Set dialect to QF_IDL

SMT=idl

# =============================================================================
# Local Functions

function cleanup()
{
  for f in $purge
  do
    rm -f $f
  done
}

function toclean()
{
  if [ $# -gt 0 ]
  then
    touch $*
    purge=$purge" "$*
    trap cleanup EXIT
  fi
}

# =============================================================================

ground=$TMP/$$-ground.sm
symfile=$TMP/$$-symbols.sm
tmpfile=$TMP/$$-file.sm
theory=$TMP/$$-ground.$SMT
model=$TMP/$$-model.txt

toclean $ground $symfile $tmpfile $theory $model

# GROUND

$BIN/gringo $* $DEF/ext-$SMT.lp \
| $BIN/lpcat -m -s=$symfile > $ground 2>> /dev/null
if test $? -ne 0
then
  echo "$0: grounding '""$*""' failed!"
  exit -1
fi

# EXTRACT SYMBOLS

cat $symfile \
| egrep -v -f $DEF/type-egrep-$SMT.txt > $tmpfile
rm -f $symfile
mv -f $tmpfile $symfile

# SMT LIB HEADER

echo "(benchmark asp_plus_$SMT" > $theory
echo ":logic QF_`echo -n $SMT | tr '[:lower:]' '[:upper:]'`" >> $theory

# TYPE DEFINITIONS

egrep -f $DEF/type-egrep-$SMT.txt $ground \
| sed 's/[1-9][0-9]* //g' \
| sed 's/_/__/g;s/(/_l/g;s/,/_c/g;s/)/_r/g' \
| sed 's/int_l/int(_/g;s/_r$/)/g' \
| cat $DEF/def-$SMT.m4 - \
| m4 - \
| egrep -v '^$' >> $theory
if test $? -gt 1
then
  echo "$0: failed to handle types of theory variables!"
  exit -1
fi

# ASP TRANSLATION

$BIN/lp2diff $ground | tail -n +3 | head -n -1 >> $theory

# THEORY ATOMS

read filter < $DIR/def/filter-egrep-$SMT.txt

egrep "$filter" $ground \
| $BIN/quote \
| sed 's/(/ /;s/)$//g' \
| awk '{printf("%s(%i,_%s,_%s,%i)",$2,$1,$3,$4,$5);}' \
| cat $DEF/def-$SMT.m4 - \
| m4 - \
| egrep -v '^$' \
| sed 's/(iff/  (iff/g' >> $theory
if test $? -ne 0
then
  echo "$0: failed to translate theory atoms themselves!"
  exit -1
fi

# SMT LIB FOOTER

echo "))" >> $theory

# SOLVE

$BIN/z3 -m $theory > $model
if test $? -ne 0
then
  echo "$0: z3 did not accept the input!"
  exit -1
fi

# PRINT

if egrep "^unsat$" $model 1>/dev/null
then
  echo "UNSATISFIABLE"
else
  if egrep "^sat$" $model 1>/dev/null
  then
    echo "SATISFIABLE"
    if test "`basename $0`" != "asp+smt+filter.sh"
    then
      filter=''
    fi
    fgrep "var_" $model \
    | fgrep " -> true" \
    | sed 's/var_//g' \
    | sed 's/ -> true//g' \
    | $BIN/interpret $symfile \
    | egrep -v '^$'\
    | egrep -v '^'$filter'$' \
    | tr -d "\n"
    echo ""
    egrep '_[a-z].* -> [-]*[0-9][0-9]*' $model \
    | sed 's/_//;s/ -> /=/g' \
    | sed 's/_l/(/g;s/_c/,/g;s/_r/)/g;s/__/_/g' \
    | tr "\n" " "
    echo ""
  else
    echo "UNKNOWN"
  fi
fi
