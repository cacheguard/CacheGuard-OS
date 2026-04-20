#!/bin/bash

clean-up-tools()
{
    test -d /tools || return 0

    rm -rf /usr/share/{info,man,doc}/*
    find /usr/{lib,libexec} -name \*.la -delete
    rm -rf /tools
}

# Main()

clean-up-tools
