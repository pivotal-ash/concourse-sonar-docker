#!/bin/bash
set -e

cp /concourse/resolv.conf /etc/

/etc/init.d/postgresql restart
sleep 5
/concourse/concourse web --basic-auth-username admin --basic-auth-password admin --session-signing-key /concourse/session_signing_key --tsa-host-key /concourse/host_key --tsa-authorized-keys /concourse/authorized_worker_keys &
sleep 5
/concourse/concourse worker --work-dir /concourse/worker --tsa-host localhost --tsa-public-key /concourse/host_key.pub --tsa-worker-private-key /concourse/worker_key
