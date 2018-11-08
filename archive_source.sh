#!/bin/bash

cd `dirname $0`
dname=`pwd`
prjname=`basename $dname`
datestr=`date +%Y%m%d-%H%M%S`
rm -rf .tmp
mkdir -p ".tmp/$prjname"
cp -a * ".tmp/$prjname"
pushd .tmp && ./$prjname/clean_vivado.sh && \
  tar cvfz "../../$prjname-$datestr.tar.gz" "$prjname" && popd
rm -rf .tmp
