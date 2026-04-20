#!/bin/bash

source CacheGuard.env

# Main()

mkdir -p ${BASE_GENERATED_DIR}/${HTML_GENERATED_DIR}
ln -sf ${BASE_GENERATED_DIR}/${HTML_GENERATED_DIR}

make --quiet
