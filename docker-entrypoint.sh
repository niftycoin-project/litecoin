#!/bin/bash

set -ex

if [ ! -e "$HOME/.niftycoin/niftycoin.conf" ]; then
    mkdir -p $HOME/.niftycoin

	echo "Creating niftycoin.conf"

	# Seed a random password for JSON RPC server
	cat <<EOF > $HOME/.niftycoin/niftycoin.conf
		disablewallet=${DISABLEWALLET:-1}
		printtoconsole=${PRINTTOCONSOLE:-1}
		rpcuser=${RPCUSER:-niftycoinrpc}
		rpcpassword=${RPCPASSWORD:-`dd if=/dev/urandom bs=33 count=1 2>/dev/null | base64`}
EOF
fi

cat $HOME/.niftycoin/niftycoin.conf

echo "Initialization completed successfully"


if [ $# -gt 0 ]; then
    args=("$@")
else
    args=("-rpcallowip=::/0")
fi

exec niftycoind "${args[@]}"
