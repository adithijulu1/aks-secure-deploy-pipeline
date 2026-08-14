#!/usr/bin/env bash
set -euo pipefail

# Provisions a new Azure DevOps self-hosted build agent VM using Puppet.

AGENT_NAME=${1:-build-agent-01}

echo "Applying Puppet manifest for $AGENT_NAME..."
puppet apply --modulepath=./puppet/modules ./puppet/manifests/site.pp

echo "Registering agent with Azure DevOps pool..."
./config.sh --unattended \
  --url "$AZP_URL" \
  --auth pat \
  --token "$AZP_TOKEN" \
  --pool "$AZP_POOL" \
  --agent "$AGENT_NAME" \
  --acceptTeeEula

echo "Agent $AGENT_NAME provisioned and registered."
