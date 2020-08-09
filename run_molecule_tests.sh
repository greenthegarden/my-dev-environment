#!/usr/bin/env bash

# run default (debian10)
molecule test

# run with centos7 image
MOLECULE_DISTO=centos7 molecule test
