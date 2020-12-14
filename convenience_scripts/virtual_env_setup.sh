#!/bin/bash

echo 'Installing python3-venv'
sudo apt-get update
sudo apt-get install -y python3-venv

echo 'Creating virtual environment in ./venv/'
python3 -m venv ./venv/

echo 'Activating virtual environment'
source ./venv/bin/activate

echo 'Updating pip before installing Python dependencies'
pip install --upgrade pip

echo 'Installing Python dependencies'
pip install -r ./requirements.txt
