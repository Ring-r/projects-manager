#!/usr/bin/env sh

set -eux
set -o | grep -q pipefail && set -o pipefail


unlink /usr/local/bin/create-project
