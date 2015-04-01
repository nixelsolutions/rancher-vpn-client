#!/bin/bash

[ "$DEBUG" == "1" ] && set -x

prepare-vpn.sh

/usr/bin/supervisord
