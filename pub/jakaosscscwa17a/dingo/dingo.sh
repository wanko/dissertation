#!/bin/bash

# Translator for combining ASP and difference logic (DL)
# based on the approach described in the GTTV 2011 paper:
#
# T. Janhunen, G. Liu, and I. Niemela: Tight Integration of
# Non-Ground Answer Set Programming and Satisfiability Modulo Theories
#
# (c) 2011, 2017 Tomi Janhunen

DIR=.        # Consider replacing this by the absolute path (pwd)
TMP=$DIR/tmp
BIN=$DIR/bin
DEF=$DIR/def

# USAGE: dingo.sh [--ground-only|--translate-only] <gringo arguments>

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

input=$TMP/$$-input.lp
ground=$TMP/$$-ground.sm
symfile=$TMP/$$-symbols.sm
translation=$TMP/$$-ground.dl
model=$TMP/$$-model.txt
assignment=$TMP/$$-model2.txt

# Declare temporary files for removal upon exit

toclean $input $ground $symfile $translation $model $assignment

# OPTIONS

case "$1" in
--ground-only) let gnd=1
               shift;;
--translate-only) let gnd=2
                  shift;;
*) gnd=0;;
esac

# DEFINE EXTERNALS

cat $* > $input
cat $BIN/external.m4 $input | m4 \
| egrep '^cnt\(_dl_l[et],[0-9]*\)$|^cnt\(_dl_g[et],[0-9]*\)$|^cnt\(_dl_eq,[0-9]*\)$|^cnt\(_dl_ne,[0-9]*\)$' | sort \
| uniq | sed 's/cnt(_/#external /g;s#,#/#g;s/)/./g' >> $input

# GROUND

$BIN/gringo $input | $BIN/lpcat -m -s=$symfile > $ground 2>> /dev/null
if test $? -ne 0
then
  echo "$0: grounding '""$*""' failed!"
  exit -1
fi

# GROUND ONLY

if test $gnd -eq 1
then
  $BIN/lplist $ground
  exit 0
fi

# ASP TRANSLATION

$BIN/lp2diff --dingo $ground > $translation

# TRANSLATE ONLY

if test $gnd -gt 1
then
  cat $translation
  exit 0
fi

# SOLVE

$BIN/z3 -smt2 $translation > $model
if test $? -ne 0 -a $? -ne 1
then
  echo "$0: z3 did not accept the input!"
  exit -1
else
  # Extract the assignement from lisp-like syntax
  cat $model | fgrep -v "model is not available" \
  | tr "\n" " " \
  | sed 's/ (model//g;s/ )//g' \
  | sed 's/   / /g;s/   / /g;s/ (define-fun /'"\n"'/g;s/- /-/g' \
  | fgrep -v 'false' \
  | sed 's/(//g;s/)//g;s/  / /g' > $assignment
fi

# PRINT

pat='^dl_le\(.*\)|dl_lt\(.*\)|dl_ge\(.*\)|dl_gt\(.*\)|dl_eq\(.*\)|dl_ne\(.*\)$'

if egrep "^unsat $" $assignment 1>/dev/null
then
  echo "UNSATISFIABLE"
else
  if egrep "^sat $" $assignment 1>/dev/null
  then
    echo "SATISFIABLE"
    fgrep "Bool true" $assignment \
    | egrep -v '^body_' \
    | sed 's/var_//g;s/ Bool true//g' \
    | $BIN/interpret $symfile \
    | egrep -v '^$' \
    | egrep -v "$pat" \
    | tr -d "\n"
    echo ""
    echo -n "Theory: "
    fgrep "Bool true" $assignment \
    | sed 's/var_//g;s/ Bool true//g' \
    | $BIN/interpret $symfile \
    | egrep -v '^$' \
    | egrep "$pat" \
    | tr -d "\n"
    echo ""
    echo -n "Vars: "
    fgrep 'Int' $assignment \
    | sed 's/ Int /=/g' \
    | sed 's/_l/(/g;s/_c/,/g;s/_r/)/g;s/_u/_/g' \
    | sed 's/^_//g;s/ //g' \
    | sort \
    | tr "\n" " "
    echo ""
  else
    echo "UNKNOWN"
  fi
fi
