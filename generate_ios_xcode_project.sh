#!/bin/bash

QT_DIR=${HOME}/Qt/5.15.2
XCODE_DIR="build-Parlance-ios"
PRO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p ${PRO_DIR}/../${XCODE_DIR}
cd ${PRO_DIR}/../${XCODE_DIR}
${QT_DIR}/ios/bin/qmake -spec macx-xcode ${PRO_DIR}/Parlance.pro
