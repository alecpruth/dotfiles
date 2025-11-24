# Source Omarchy defaults if on Omarchy (Linux)
if [[ -f ~/.local/share/omarchy/default/bash/rc ]]; then
  source ~/.local/share/omarchy/default/bash/rc
fi

# Oh-My-Zsh configuration (for Mac or non-Omarchy systems)
if [[ ! -f ~/.local/share/omarchy/default/bash/rc ]]; then
  export ZSH="${HOME}/.oh-my-zsh"
  ZSH_THEME=""  # Use Starship instead
  plugins=(git)

  # Load Oh-My-Zsh if installed
  if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
  fi
fi

# FZF configuration
if command -v fzf &> /dev/null; then
  eval "$(fzf --zsh)"
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
fi

# Exports
export PATH="$HOME/.local/bin:$PATH"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ -x /usr/libexec/java_home ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
  fi
fi

# System aliases
alias updateOS="yay -Syu"
alias reload="source ~/.zshrc"
alias sshagent="eval \$(ssh-agent -s)"
alias myshell="vim ~/.zshrc"
alias vim="nvim"

# Git & Dev tools
alias lg="lazygit"

# AWS aliases
alias awsclient='aws-azure-login --profile client --no-prompt && export AWS_PROFILE=client && export AWS_DEFAULT_REGION=us-east-1 && export AWS_REGION=us-east-1'
alias awsdev='aws-azure-login --profile dev --no-prompt && export AWS_PROFILE=dev && export AWS_DEFAULT_REGION=us-east-1 && export AWS_REGION=us-east-1'
alias awsdevreset='aws-azure-login --profile dev --mode gui --no-prompt && export AWS_PROFILE=dev && export AWS_DEFAULT_REGION=us-east-1 && export AWS_REGION=us-east-1'
alias aws-dev='aws-azure-login --profile dev --no-prompt && export AWS_PROFILE=dev && export AWS_DEFAULT_REGION=us-east-1 && export AWS_REGION=us-east-1 && export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain nw-testing --domain-owner 547097428470 --query authorizationToken --output text`'
alias codeartifact='export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain nw-testing --domain-owner 547097428470 --query authorizationToken --output text`'
alias workinit="aws-azure-login --profile dev --no-prompt && export AWS_PROFILE=dev && export AWS_DEFAULT_REGION=us-east-1 && export AWS_REGION=us-east-1 && export CODEARTIFACT_AUTH_TOKEN=\$(aws codeartifact get-authorization-token --domain nw-testing --domain-owner 547097428470 --query authorizationToken --output text); aws ec2 start-instances --instance-ids i-0544e4cb3109c51c8"
alias gohome="aws ec2 stop-instances --instance-ids i-0544e4cb3109c51c8"
alias turnon="aws ec2 start-instances --instance-ids i-0544e4cb3109c51c8"
alias remoteserver="ssh -L 8084:localhost:8084 alec.ruth@10.1.27.48"
alias vpnstart="sudo systemctl restart awsvpnclient"

# Initialize Starship prompt (if not already initialized by Omarchy)
if command -v starship &> /dev/null; then
  if ! typeset -f starship_precmd > /dev/null 2>&1; then
    eval "$(starship init zsh)"
  fi
fi
