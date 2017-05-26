#!/bin/sh

# install python
apt-get update
apt-get install -y python
apt-get install -y python-pip python-dev
pip install --upgrade pip