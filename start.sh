#!/bin/sh
cd `dirname $0`

exec erl -pa $PWD/ebin -pa $PWD/deps/*/ebin -name web"@"$HOSTNAME \
    -s n2o_tabs_app start -config ebin/n2o_tabs
