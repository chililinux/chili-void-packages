#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1091,SC2039,SC2166

# https://docs.voidlinux.org/xbps/repositories/signing.html
# Signing Repositories
# Remote repositories must be signed. Local repositories do not need to be signed.
# The xbps-rindex(1) tool is used to sign repositories.
# The private key for signing packages needs to be a PEM-encoded RSA key. The key can be generated with either ssh-keygen(1) or openssl(1):

repo="$PWD/hostdir/binpkgs"
packager='Vilmar Catafesta <vcatafesta@gmail.com>'

if [[ ! -e private.pem ]]; then
#	openssl genrsa -des3 -out privkey.pem 4096
#	ssh-keygen -t rsa -b 4096 -m PEM -f privkey.pem
	ssh-keygen -t rsa -m PEM -f private.pem
#	openssl genrsa -out private.pem
fi

#remove old
rm -vf $repo/x86_64-repodata
#remove old .sig2
rm -vf $repo/*.sig2

#cria x86_repodata
xbps-rindex -v --add --force $repo/*.xbps

# Once the key is generated, the public part of the private key has to be added to the repository metadata. This step is required only once.
xbps-rindex -v --privkey private.pem --sign --signedby "$packager" "$repo"
# Then sign one or more packages with the following command:

xbps-rindex -v --privkey private.pem --sign-pkg "$repo"/*.xbps
# Note that future packages will not be automatically signed.


