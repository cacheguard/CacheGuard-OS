#!/bin/bash

test -n "${LFS}" || exit 1

source CacheGuard.env

install-embedded-vpn()
{
    cd VPNSubscr
    ./install.bash "${@}"
    cd ..
}

main()
{
    install-embedded-vpn "${@}"
}

# Main()

main "${@}"
