#!/bin/sh
pkgdir=/var/cache/apt/archives
cd $pkgdir
sudo dpkg -i netfilter-persistent*.deb

sudo dpkg -i libip*.deb
sudo dpkg -i iptables_*.deb
sudo dpkg -i iptables-*.deb
