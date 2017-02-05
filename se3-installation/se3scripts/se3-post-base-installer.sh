#!/bin/sh
set -e
# Retrieve setup_se3.data from the same directory as the preseed file.
# Retrieve  profile bashrc  script install-phase2.sh from the same directory as the  preseed file.
# XXX: might simple use wget here to retrieve from somewhere else

mkdir  /target/etc/se3
mv setup_se3.data /target/etc/se3/setup_se3.data
mv install_phase2.sh /target/root/install_phase2.sh
mv profile /target/root/.profile
mv bashrc /target/root/.bashrc
#cp se3.list /target/etc/apt/sources.list.d/se3.list
#mv se3.list /target/etc/se3/se3.list
#mv sources.list /target/etc/apt/sources.list
# ajout pour l'autologin
mv /target/etc/inittab /target/etc/inittab.orig
mv inittab /target/etc/inittab
cp /target/etc/inittab /target/root/
