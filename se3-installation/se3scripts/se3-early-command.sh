#!/bin/sh

set -e

# Retrieve post-base-installer script from the same directory as the
# preseed file.
mv se3-post-base-installer.sh /usr/lib/post-base-installer.d/90se3
