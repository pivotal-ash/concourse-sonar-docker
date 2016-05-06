#!/bin/bash
set -e

sed -i 's/md5$/trust/g' /etc/postgresql/*/main/pg_hba.conf

/etc/init.d/postgresql restart

su - postgres -c "createuser root"
su - postgres -c "createdb -O root atc"

cd /concourse

echo "Downloading concourse..."
wget -q -O concourse 'https://github.com/concourse/concourse/releases/download/v1.1.0/concourse_linux_amd64'
chmod +x concourse
echo "Downloading concourse complete"

ssh-keygen -t rsa -f host_key -N ''
ssh-keygen -t rsa -f worker_key -N ''
ssh-keygen -t rsa -f session_signing_key -N ''
cp worker_key.pub authorized_worker_keys

./start.sh &
echo "Waiting for concourse to start..."
sleep 10
echo "Done waiting"

echo "Downloading fly..."
wget -q -O fly --user=admin --password=admin --auth-no-challenge 'http://localhost:8080/api/v1/cli?arch=amd64&platform=linux'
chmod +x fly
echo "Downloading fly complete"

DOCKER_IP=`netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}'`
sed -i'' -e "s/{{DOCKER_IP}}/${DOCKER_IP}/g" pipeline.yml

./fly -t static-analysis login -c http://localhost:8080 -u admin -p admin
./fly -t static-analysis set-pipeline -p static-analysis -c pipeline.yml -n
./fly -t static-analysis unpause-pipeline -p static-analysis

sleep 5
