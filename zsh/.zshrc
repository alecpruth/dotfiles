# Only show fastfetch on login shells, not on new tabs
if [[ -o login ]]; then
  fastfetch
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline --preview="bat --style=numbers --color=always --line-range :500 {}" --preview-window=right:60%:wrap'
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
export FZF_TMUX_OPTS="-p90%,70%"
# Path to your oh-my-zsh installation
export ZSH="${HOME}/.oh-my-zsh"
export JAVA_HOME=$(/usr/libexec/java_home)
export PNPM_HOME="${HOME}/.local/share/pnpm"::
# export OPEN_API_KEY='your-api-key-here'  # Add your own API key
export TERM=xterm-256color
# PHP
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.local/bin:"$PATH
export PATH="${PNPM_HOME}:$PATH"
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# https://github.com/caiogondim/bullet-train.zsh
# colornumbers https://unix.stackexchange.com/questions/105568/how-can-i-list-the-available-color-names
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

# brew install zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/oh-my-zsh.sh
export NODE_OPTIONS="--max_old_space_size=8192"

# Shorthand for editing this hidden file (use whatever text editor you prefer)
alias myshell="vim ~/.zshrc"
alias ls="eza --long --color=always --icons=always --no-user"
#alias myshell="open -a BBEdit ~/.zshrc"

# These allow the nw.sh files in each of our repositories to work
MY_DEVELOPMENT="$HOME/development"
nw() {
 if git rev-parse --git-dir > /dev/null 2>&1; then
   REPO_ROOT=$(git rev-parse --show-toplevel);
   $REPO_ROOT/nw.sh "$@"
 else
   cd $MY_DEVELOPMENT/nw-client/
   ./nw.sh "$@"
 fi
}
client() {
  cd $MY_DEVELOPMENT/nw-client/client-source && nw "$@"
}
nwlogin() {
  cd $MY_DEVELOPMENT/nw-login && nw "$@"
}
mob() {
  cd $MY_DEVELOPMENT/nw-mobile && nw "$@"
}

cherry() {
  read "cherryBranch?Get cherry commits from which branch? "
  echo cherry commits from $cherryBranch
  print git cherry -v origin/$cherryBranch
  cherryCommits=$(git cherry -v origin/$cherryBranch | awk '{ print $2; }' | xargs)
  echo The commits that will be used \n $cherryCommits
  read "cherryPickBranchOrigin?Name of origin branch (E.x. sprint_167)? "
  echo checking out $cherryPickBranchOrigin and pulling
  git checkout $cherryPickBranchOrigin && git pull
  read "cherryPickBranch?Name of new branch for cherry-pick? "
  git checkout -b $cherryPickBranch
  echo cherry-pick into $cherryPickBranch
  git cherry-pick -x $cherryCommits
  echo \n Push cherry-pick to complete
}

cherrytest() {
  read "cherryBranch?Get cherry commits from which branch?"
  echo cherry commits from $cherryBranch
  cherryCommits=$(git cherry -v origin/$cherryBranch | awk '{ print; }' | xargs)
  echo $cherryCommits
}

partnerGen() {
  read "partnerTenant?What partner tenant would you like to gen in? "
  read "application?What application would you like gen? "
  echo genning $application in $partnerTenant
  ng run client-source:gen --gen-zone PartnerDev.master --gen-password Ilmp#2030 --gen-username alec.ruth@nextworld.net --gen-server https://api-partner-master.nextworld.net/PartnerDev.master --gen-tenant $partnerTenant -d $application
}

# Remove any generated apps command (run from the client source working directory)
alias rm-gen-apps="git ls-files --others -i --exclude-standard src/client/genapp --directory | grep -v DS_Store | xargs rm -rf"

# Output the current git branch
alias git-current-branch="git symbolic-ref -q HEAD | awk -F '/' '{ printf \$NF }' -"
# Copy the current git branch to the mac clipboard
alias git-copy-branch-name="git symbolic-ref -q HEAD | awk -F '/' '{ printf \$NF }' - | pbcopy -"

# Command to regenerate without downloading a new generation jar (the --noDownload option)
# ng run client-source:gen --noDownload -d PDNWTStockGift,peter_d,ToolsDev.dev

# Commands to run in nw-client/client-source/
#alias clientsonar="npm run sonar.scanner"
# To run unit tests in a "watch" mode: ng test -c debug
#alias headedtest="client .;pkill -9 gulp;ng test --browsers=Chrome"
#alias chrometest="client .;pkill -9 gulp;ng test --browsers=ChromeHeadless"
#alias chromiumtest="client .;pkill -9 gulp;ng test --browsers=ChromiumHeadless"
#alias chromedebugtest="client .;pkill -9 gulp;ng test --browsers=Chrome --watch"
#alias chromiumdebugtest="client .;pkill -9 gulp;npm run test.single -- --browser=Chromium"
#alias debugtest="client .;pkill -9 gulp;npm run debug.test"
function setRecordingDevice() {
  { # try
    ffmpeg -f avfoundation -list_devices true -i "" 2>&1 >/dev/null | grep "Capture screen 0" | sed -n 's/.*\[\([0-9]\)\].*/\1/p' | {
      read display; export RECORDING_DEVICE=$display
    }
    # echo $RECORDING_DEVICE
  } || { # catch
    echo "Error in setRecordingDevice"
  }
}
alias snippettest="client .;rm -rf test-results/e2e-test-html/videos/*.mov;setRecordingDevice;HEADED=false npm run e2e"
alias snippettestheaded="client .;rm -rf test-results/e2e-test-html/videos/*.mov;setRecordingDevice;HEADED=true npm run e2e"
alias reload="source ~/.zshrc"
alias cleangen="ng run client-source:clean-gen"
alias gen="ng run client-source:gen -d"
alias genpartner="ng run client-source:gen --gen-zone PartnerDev.master --gen-password Ilmp#2030 --gen-username alec.ruth@nextworld.net --gen-server https://api-partner-master.nextworld.net/PartnerDev.master --gen-tenant cloudinv -d"
alias php8="brew unlink php@7.4; brew link php@8.1; corepack prepare pnpm@7.27.0 --activate"
alias php7="brew unlink php@8.1; brew link php@7.4; corepack prepare pnpm@7.6.0 --activate"
alias vim="nvim"
alias awsclient="aws-azure-login --profile client --no-prompt && export AWS_PROFILE=client && export AWS_DEFAULT_REGION=us-east-1 && export AWS_REGION=us-east-1 && export CODEARTIFACT_AUTH_TOKEN=\$(aws codeartifact get-authorization-token --domain nw-testing --domain-owner 547097428470 --query authorizationToken --output text)"
alias awsclientrp="aws-azure-login --profile clientrp --no-prompt && export AWS_PROFILE=clientrp && export AWS_DEFAULT_REGION=us-east-1 && export AWS_REGION=us-east-1"
alias awsclientreset="aws-azure-login --profile client --mode gui --no-prompt && export AWS_PROFILE=client && export AWS_DEFAULT_REGION=us-east-1 && export AWS_REGION=us-east-1"
alias awsclientrpreset="aws-azure-login --profile clientrp --mode gui --no-prompt && export AWS_PROFILE=client && export AWS_DEFAULT_REGION=us-east-1 && export AWS_REGION=us-east-1"
alias workinit="aws-azure-login --profile dev --no-prompt && export AWS_PROFILE=dev && export AWS_DEFAULT_REGION=us-east-1 && export AWS_REGION=us-east-1 && export CODEARTIFACT_AUTH_TOKEN=\$(aws codeartifact get-authorization-token --domain nw-testing --domain-owner 547097428470 --query authorizationToken --output text); aws ec2 start-instances --instance-ids i-0544e4cb3109c51c8"
alias gohome="aws ec2 stop-instances --instance-ids i-0544e4cb3109c51c8"
alias turnon="aws ec2 start-instances --instance-ids i-0544e4cb3109c51c8"
alias remoteserver="ssh -L 8084:localhost:8084 alec.ruth@10.1.27.48"
alias lg="lazygit"
alias rpr="gh pr list --search "review-requested:@me""
alias myprs="gh pr list --author @me"
alias ij='open -a "IntelliJ IDEA Ultimate"'
alias vault='cd "/Users/alecruth/Library/Mobile Documents/iCloud~md~obsidian/Documents/Life Vault"'
# Load Angular CLI autocompletion.
# source <(ng completion script)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Nextworld Frontend Tools
source /Users/alecruth/Development/frontend-tools/zsh/zshrc
