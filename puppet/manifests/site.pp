# Site manifest for self-hosted Azure DevOps build agents
node /^build-agent-\d+$/ {
  include build_agent
}
