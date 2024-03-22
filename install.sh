#!/usr/bin/env sh

set -eux
set -o | grep -q pipefail && set -o pipefail

SCRIPT_ROOT_DIR=$( CDPATH= cd -- "$(dirname -- "$0")" && pwd -P )

ln "$SCRIPT_ROOT_DIR/src/create.sh" /usr/local/bin/create-project
chmod u+x /usr/local/bin/create-project
