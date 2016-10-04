#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pip install --upgrade pip
pip install --ignore-installed --require-hashes --no-cache-dir -r ${DIR}/requirements.txt