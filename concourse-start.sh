#!/bin/bash
set -e
/etc/init.d/postgresql restart
/concourse/concourse_linux_amd64 web --basic-auth-username admin --basic-auth-password admin --session-signing-key /concourse/session_signing_key --tsa-host-key /concourse/host_key --tsa-authorized-keys /concourse/authorized_worker_keys
