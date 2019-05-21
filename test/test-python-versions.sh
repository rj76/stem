#!/bin/bash

export WORKSPACE=`pwd`

UNIT_TEST_ARGS="--unit -v"
INTEG_TEST_ARGS="--integ -v --target RUN_ALL"

TOR_VERSION="0.4.0.5"

wget https://dist.torproject.org/tor-$TOR_VERSION.tar.gz
tar zxf tor-$TOR_VERSION.tar.gz && cd tor-$TOR_VERSION

BASE_TOR_DIR=`pwd`

./configure && make -j4

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

python run_tests.py $UNIT_TEST_ARGS --tor $WORKSPACE/tor-0.4.0.5/src/app/tor
python run_tests.py $INTEG_TEST_ARGS --tor $WORKSPACE/tor-0.4.0.5/src/app/tor

# 3.6
source $WORKSPACE/venv-3.6/bin/activate
pip install -U pip
pip install -r requirements.txt

python run_tests.py $UNIT_TEST_ARGS --tor $WORKSPACE/tor-0.4.0.5/src/app/tor
python run_tests.py $INTEG_TEST_ARGS --tor $WORKSPACE/tor-0.4.0.5/src/app/tor

# 3.7
source $WORKSPACE/venv-3.7/bin/activate
pip install -U pip
pip install -r requirements.txt

python run_tests.py $UNIT_TEST_ARGS --tor $WORKSPACE/tor-0.4.0.5/src/app/tor
python run_tests.py $INTEG_TEST_ARGS --tor $WORKSPACE/tor-0.4.0.5/src/app/tor
