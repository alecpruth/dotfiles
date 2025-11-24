# Dotfiles

Personal dotfiles managed with GNU Stow for macOS and Linux.

## Structure

Each directory represents a Stow package that can be independently installed.

### Cross-Platform (macOS & Linux)

- **zsh** - Zsh shell configuration (.zshrc, .zshenv, .zprofile, .p10k.zsh)
- **vim** - Vim editor configuration
- **nvim** - Neovim configuration
- **lvim** - LunarVim configuration
- **tmux** - Terminal multiplexer configuration
- **git** - Git configuration (.gitconfig, .gitconfig-personal)
- **ssh** - SSH client configuration
- **alacritty** - Alacritty terminal emulator
- **ghostty** - Ghostty terminal emulator
- **kitty** - Kitty terminal emulator
- **btop** - System monitor configuration
- **htop** - Interactive process viewer configuration
- **neofetch** - System information tool configuration
- **gh** - GitHub CLI configuration

### macOS Only

- **aerospace** - AeroSpace window manager configuration
- **iterm2** - iTerm2 configuration
- **hyper** - Hyper terminal configuration

## Prerequisites

Install GNU Stow:

**macOS:**
```bash
brew install stow
```

**Linux (Debian/Ubuntu):**
```bash
sudo apt install stow
```

**Linux (Arch):**
```bash
sudo pacman -S stow
```

**Linux (Fedora):**
```bash
sudo dnf install stow
```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/alecpruth/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. **Option A - Install all compatible packages:**

For macOS:
```bash
stow */
```

For Linux (exclude macOS-only packages):
```bash
stow zsh vim nvim lvim tmux git ssh alacritty ghostty kitty btop htop neofetch gh
```

3. **Option B - Install specific packages:**
```bash
# Essential shell setup
stow zsh git

# Add editor
stow vim
# or
stow nvim

# Add terminal emulator
stow alacritty
# or
stow kitty

# Add additional tools
stow tmux btop gh
```

## Uninstallation

Remove symlinks for a specific package:
```bash
cd ~/dotfiles
stow -D PACKAGE_NAME
```

Remove all packages:
```bash
cd ~/dotfiles
# macOS
stow -D */

# Linux
stow -D zsh vim nvim lvim tmux git ssh alacritty ghostty kitty btop htop neofetch gh
```

## Adding New Dotfiles

1. Create a new directory for the package:
```bash
mkdir ~/dotfiles/PACKAGE_NAME
```

2. Mirror the home directory structure inside:
```bash
# For a file that goes in ~/
cp ~/.someconfig ~/dotfiles/PACKAGE_NAME/.someconfig

# For a file that goes in ~/.config/
mkdir -p ~/dotfiles/PACKAGE_NAME/.config
cp -r ~/.config/someapp ~/dotfiles/PACKAGE_NAME/.config/
```

3. Stow the package:
```bash
cd ~/dotfiles
stow PACKAGE_NAME
```

## Notes

- Existing files will NOT be overwritten - Stow will show a warning if conflicts exist
- SSH config is included but does NOT contain private keys
- Some configs require additional software:
  - **zsh configs**: Requires [oh-my-zsh](https://ohmyz.sh/) and [powerlevel10k](https://github.com/romkatv/powerlevel10k)
  - **lvim**: Requires [LunarVim](https://www.lunarvim.org/)
- Review git configuration and update with your personal details before using

## Quick Start Examples

**New macOS machine:**
```bash
git clone https://github.com/alecpruth/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh git tmux alacritty nvim gh aerospace
```

**New Linux machine:**
```bash
git clone https://github.com/alecpruth/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh git tmux alacritty nvim gh btop
```
