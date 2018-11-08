#!/bin/bash

cd `dirname $0`
rm -rf *.cache *.hw *.impl *.ip_user_files *.runs *.sim *.jou *.log .Xil
rm -rf *.srcs/*/bd/*/ip
rm -rf *.srcs/*/bd/*/ipshared
rm -rf *.mcs *.prm
#pushd dmatest && make clean && popd
