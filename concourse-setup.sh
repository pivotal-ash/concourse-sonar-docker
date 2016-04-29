#!/bin/bash
set -e

sed -i 's/md5$/trust/g' /etc/postgresql/*/main/pg_hba.conf

/etc/init.d/postgresql restart

su - postgres -c "createuser root"
su - postgres -c "createdb -O root atc"

cd /concourse

echo "Downloading concourse..."
wget -q 'https://github.com/concourse/concourse/releases/download/v1.1.0/concourse_linux_amd64'
chmod +x concourse_linux_amd64
echo "Downloading concourse complete"

ssh-keygen -t rsa -f host_key -N ''
ssh-keygen -t rsa -f worker_key -N ''
ssh-keygen -t rsa -f session_signing_key -N ''
cp worker_key.pub authorized_worker_keys
