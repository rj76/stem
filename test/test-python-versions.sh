#!/bin/bash

export WORKSPACE=`pwd`

UNIT_TEST_ARGS="--unit -v"
INTEG_TEST_ARGS="--integ -v --target RUN_ALL"

TOR_VERSION="0.4.0.5"

wget https://dist.torproject.org/tor-$TOR_VERSION.tar.gz
tar zxf tor-$TOR_VERSION.tar.gz && cd tor-$TOR_VERSION

BASE_TOR_DIR=`pwd`

if test -z "$CPU_CORE_COUNT"; then
  CPU_CORE_COUNT=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
fi

./configure && make -j$CPU_CORE_COUNT

# export these for usage in tests
export GEO_IP_FILE="$BASE_TOR_DIR/src/config/geoip"
export TOR_BINARY="$BASE_TOR_DIR/src/app/tor"

cd $WORKSPACE

# Create virtualenvs
virtualenv --python=python2.7 $WORKSPACE/venv-2.7
virtualenv --python=python3.6 $WORKSPACE/venv-3.6
virtualenv --python=python3.7 $WORKSPACE/venv-3.7

# 2.7
source $WORKSPACE/venv-2.7/bin/activate
pip install -U pip
pip install -r requirements.txt

python run_tests.py $UNIT_TEST_ARGS --tor $TOR_BINARY
python run_tests.py $INTEG_TEST_ARGS --tor $TOR_BINARY

# 3.6
source $WORKSPACE/venv-3.6/bin/activate
pip install -U pip
pip install -r requirements.txt

python run_tests.py $UNIT_TEST_ARGS --tor $TOR_BINARY
python run_tests.py $INTEG_TEST_ARGS --tor $TOR_BINARY

# 3.7
source $WORKSPACE/venv-3.7/bin/activate
pip install -U pip
pip install -r requirements.txt

python run_tests.py $UNIT_TEST_ARGS --tor $TOR_BINARY
python run_tests.py $INTEG_TEST_ARGS --tor $TOR_BINARY
