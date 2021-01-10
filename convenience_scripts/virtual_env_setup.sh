#!/bin/bash

echo 'Creating virtual environment in ./venv/'
python3 -m venv ./venv/

echo 'Activating virtual environment'
source ./venv/bin/activate

echo 'Updating pip before installing Python dependencies'
pip install --upgrade pip

echo 'Installing wheel'
pip install wheel

echo 'Installing Python dependencies'
pip install -r ./requirements.txt
