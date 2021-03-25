#!/usr/bin/env bash

set -e

srcdir="$1"
pypi_url="$2"
pypi_index_url="$3"
workdir="${srcdir:-/src}"
spec_file=${4:-*.spec}

python -m pip install --upgrade pip wheel setuptools pipenv pyinstaller

if [[ "$pypi_url" != "https://pypi.python.org/" ]] || \
   [[ "$pypi_index_url" != "https://pypi.python.org/simple" ]]; then
    mkdir -p /root/.pip
    cat << EOF > /root/.pip/pip.conf
[global]
index = ${pypi_url}
index-url = ${pypi_index_url}
trusted-host = $(echo $pypi_url | grep -Poe "(?<=:\/\/)[^\/]+")"
EOF

    echo "Using custom pip.conf:"
    cat /root/.pip/pip.conf
fi

cd $workdir

if [ -f Pipfile ] && ! [ -f requirements.txt ]; then
    pipenv lock -r --dev > requirements.txt
fi

if [ -f requirements.txt ]; then
    pip install -r requirements.txt
fi

pyinstaller --clean -y --dist ./dist/linux --workpath /tmp $spec_file

chown -R --reference=. ./dist/linux

