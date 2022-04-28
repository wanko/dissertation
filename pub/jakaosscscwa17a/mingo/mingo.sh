#!/bin/bash

# Translator for combining ASP and linear constraints (LC) over integers
# based on the approach described in the KR 2012 paper:
#
# T. Janhunen, G. Liu, and I. Niemela: Answer Set Programming
# via Mixed Integer Programming.
#
# (c) 2011, 2017 Tomi Janhunen

DIR=.        # Consider replacing this by the absolute path (pwd)
BIN=$DIR/bin
TMP=$DIR/tmp

# USAGE: mingo.sh [--ground-only|--translate-only] <gringo arguments>

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
translation=$TMP/$$-translation.lp
model=$TMP/$$-model.txt

# Declare temporary files for removal upon exit

toclean $input $ground $symfile $translation $model

# OPTIONS

case "$1" in
"--ground-only") gnd=1
                 shift;;
"--translate-only") gnd=2
                    shift;;
*) gnd=0;;
esac

# DEFINE EXTERNALS

cat $* > $input
cat $BIN/external.m4 $input | m4 \
| egrep '^cnt\(_m[gl]t,[0-9]*\)$|^cnt\(_m[gl]eq,[0-9]*\)$' | sort \
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

$BIN/lp2mip --mingo $ground > $translation
if test $? -ne 0
then
  echo "$0: translation with lp2mip failed!"
  exit -1
fi

# TRANSLATE ONLY

if test $gnd -gt 1
then
  cat $translation
  exit 0
fi

# SOLVE

( echo "read "$translation; \
  echo "optimize"; \
  echo "display solution variables *" ) \
| $BIN/cplex > $model 2>/dev/null
if test $? -ne 0
then
  echo "$0: cplex did not accept the input!"
  echo "$0: output of cplex:"
  cat $model
  exit -1
fi

# PRINT


if egrep "^MIP - Integer infeasible.$" $model 1>/dev/null
then
  echo "UNSATISFIABLE"
else
  if egrep "^Solution pool: [1-9][0-9]* solution[s]* saved.$" $model 1>/dev/null
  then
    echo "SATISFIABLE"
    fgrep "var_" $model | fgrep "1.000000" \
    | sed 's/var_//g' \
    | sed 's/[[:space:]]*1.000000//g' \
    | $BIN/interpret $symfile \
    | egrep -v '^$'\
    | egrep -v 'mleq\(.*\)|mlt\(.*\)|mgt\(.*\)|mgeq\(.*\)' \
    | egrep -v 'bin\(.*\)|int\(.*\)|real\(.*\)|epsilon\(.*\)' \
    | tr -d "\n"
    echo ""
    echo -n "Theory: "
    fgrep "var_" $model \
    | fgrep "1.000000" \
    | sed 's/var_//g' \
    | sed 's/[[:space:]]*1.000000//g' \
    | $BIN/interpret $symfile \
    | egrep -v '^$' \
    | egrep 'mleq\(.*\)|mlt\(.*\)|mgt\(.*\)|mgeq\(.*\)' \
    | tr -d "\n"
    echo ""
    echo -n "Vars: "
    egrep '^[[:lower:]].*[[:digit:]]+\.[[:digit:]]+$' $model \
    | egrep -v "^var_" \
    | sed 's/ /=/;s/ //g' \
    | sed 's/.000000//g' \
    | sed 's/_l/(/g;s/_r/)/g' \
    | tr "\n" " "
    echo "(other values 0)"
  else
    echo "UNKNOWN"
  fi
fi
