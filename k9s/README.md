# K9s

## Prerequisites

1. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)

- For all plugins to work, its nice to have them as your binaries.

2. [HolmesGPT](https://github.com/robusta-dev/holmesgpt?tab=readme-ov-file#installation) -
   AI analysis with `shift + H`. HolmesGPT also allows to pull tickets from Jira
   and analyze them:
   https://github.com/robusta-dev/holmesgpt?tab=readme-ov-file#enabling-integrations.
   Requires AI Provider API key, which should be exported.

3. [Helm](https://helm.sh/docs/intro/install/#from-script) - See all Helm
   releases with `ctrl + H`
4. 

## Usage

### Plugins

### Changing the default $PATH for K9s

- The default $PATH for k9s for mac is `~/Library/Application Support/k9s/` to
  change that do:

1. Put into your ~/.zshrc: `export K9S_CONFIG_DIR=$HOME/.config/k9s/`
1. `source ~/.zshrc`
1. `k9s info` to verify the new $PATH
1. Restart terminal
