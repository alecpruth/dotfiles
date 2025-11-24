export JAVA_HOME=$(/usr/libexec/java_home)
# Allow non-root usage of npm:
export NPM_PREFIX="$HOME/.npm"
export NPM_PACKAGES="${HOME}/.npm-packages"
# Location for PNPM to store caches and configuration
export PNPM_HOME="${HOME}/.local/share/pnpm"
 
# Setup PATH (can also be done in ~/.zshrc, but .zshenv is always sourced, so this will include all interactive and non-interactive terminals)
# For using globally installed npm package binaries (from "npm install -g <package>")
export PATH="$NPM_PACKAGES/bin:$PATH"
export PATH="/usr/local/opt/php@7.4/bin:$PATH"
export PATH="/usr/local/opt/php@7.4/sbin:$PATH"
. "$HOME/.cargo/env"
