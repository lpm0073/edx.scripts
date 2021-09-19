#!/bin/bash
#*************************************
# Python 3.8.12
# pip 21.2.4 from /Users/mcdaniel/github/engine/venv/lib/python3.8/site-packages/pip (python 3.8)
#*************************************
/opt/homebrew/opt/python@3.8/bin/python3 -m venv venv
source python_env
source venv/bin/activate
pip install --upgrade pip setuptools wheel
cd edx-platform
pip install -r requirements/edx/base.txt
pip install -r requirements/edx/development.txt
pip install -r requirements/edx/testing.txt

