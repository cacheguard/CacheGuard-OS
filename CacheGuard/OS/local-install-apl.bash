#!/bin/bash

find-exec()
{
    find / -type f -executable 2> /dev/null | grep --invert-match /tmp/local-install-apl.bash > /tmp/executable.lst
}

main()
{
    find-exec
}

# Main()

main
