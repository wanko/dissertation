#!/bin/bash

# Download gringo version 3.0.5

if test -x gringo
then
  echo "gringo is already available!"
  exit 0
fi

if test ! -f download
then
  wget http://sourceforge.net/projects/potassco/files/gringo/3.0.5/gringo-3.0.5-x86-linux.tar.gz/download
fi

if test -f download
then
  mv download gringo-3.0.5-x86-linux.tgz

  # Extract

  tar xvfz gringo-3.0.5-x86-linux.tgz
  mv gringo-3.0.5-x86-linux/gringo gringo

  # Cleanup

  rm -f gringo-3.0.5-x86-linux.tgz
  rm -f gringo-3.0.5-x86-linux/*
  rmdir gringo-3.0.5-x86-linux
else
  echo "Downloading gringo failed!"
fi
