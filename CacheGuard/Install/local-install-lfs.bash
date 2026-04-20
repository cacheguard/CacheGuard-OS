#!/bin/bash

source /tmp/CacheGuard.env
source /tmp/WorkFunctions

main()
{
    cd /
    gen-library-list /tmp/binaries.lst /tmp/unlinked-libraries.lst > /tmp/libraries.lst
}

# Main()

main
