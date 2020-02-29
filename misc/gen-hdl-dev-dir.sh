#!/bin/sh

[ -d $1 ] && { echo "$1 exist, abort!" ; exit 0 ; }

## gen dirs----------------------------------##
mkdir $1
cd $1
mkdir ipcore_ise14p7
mkdir ipcore_vivado2017p3
mkdir prj_ise14p7
mkdir prj_vivado2017p3
mkdir src
mkdir tb
mkdir edf

## gen readme -------------------------------##
touch readme
echo "#this is the readme file" >> readme
echo ""                         >> readme

## gen .gitignore ---------------------------##
touch .gitignore
echo "#this is the .gitignore file" >> .gitignore
echo "                            " >> .gitignore
echo "# ipcore_ise                " >> .gitignore
echo "ipcore_ise*/*               " >> .gitignore
echo "!ipcore_ise*/*.xco          " >> .gitignore
echo "!ipcore_ise*/*.xise         " >> .gitignore
echo "                            " >> .gitignore
echo "# ipcore_vivado             " >> .gitignore
echo "ipcore_vivado*/?*/*         " >> .gitignore
echo "!ipcore_vivado*/?*/*.xci    " >> .gitignore
echo "!ipcore_vivado*/?*/*.xdc    " >> .gitignore
echo "!ipcore_vivado*/?*/*.coe    " >> .gitignore
echo "                            " >> .gitignore
echo "# prj_ise & prj_vivado      " >> .gitignore
echo "prj_*/*                     " >> .gitignore
echo "!prj_*/**/*.xpr             " >> .gitignore

## gen the summary -------------------------##
echo "hdl-dev-dir $1 is created, as the following ... "
ls -la
echo "---------------------------------------- "
echo "modify readme and .gitignore as you need!"
