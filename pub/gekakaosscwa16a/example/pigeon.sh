#!/bin/bash
cd "$(dirname "$0")"
head -n -2 pigeon-py.lp | clingo-4-banane - pigeon.lp "${@}"
