# dotfiles

## Installation

### Step 1
Clone this repo
```bash
git clone https://github.com/sanj909/dotfiles.git
```

### Step 2
Install dependencies (e.g. oh-my-zsh and related plugins). You can specify options to install tmux and zsh

Installation on a mac requires homebrew so install this [from here](https://brew.sh/) first if you haven't already

```bash
# Install dependencies
./install.sh
# Install dependencies + tmux + zsh
./install.sh --tmux --zsh
```

### Step 3
Deploy (e.g. source aliases for .zshrc, apply oh-my-zsh settings, etc.)
```bash
# Local mac machine
./deploy.sh --local
# Remote linux machine
./deploy.sh
# Include simple vimrc
./deploy.sh --vim
```

### Step 4
This set of dotfiles uses the powerlevel10k theme for zsh. This makes your terminal look better and adds lots of useful features like env indicators, git status, etc.

Note that as the provided powerlevel10k config uses special icons it is *highly recommended* you install a custom font that supports these icons. A guide to do that is [here](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)

This repo comes with a preconfigured powerlevel10k theme in [`./config/p10k.zsh`](./config/p10k.zsh) but you can reconfigure this by running `p10k configure` which will launch an interactive window

When you get to the last two options, respond as below:
```bash
Powerlevel10k config file already exists.
Overwrite ~/git/sm-dotfiles/config/p10k.zsh?
# Press y for YES

Apply changes to ~/.zshrc?
# Press n for NO 
```

### Optional
Included in this repo are the onedark and onedarker color schemes for iterm

### Other examples
Linked below are some other people's dotfiles
* [Ed's](https://github.com/erees1/dotfiles) - (Very) extensive nvim config, custom tmux theme, vim keybindings in terminal, gitconfig, install scripts for nvim (nightly) and delta (nicer looking git diff)
* [John's](https://github.com/McHughes288/dotfiles) - Very similar to sm-dotfiles but has some useful vscode extensions if you'd like some recommendations

## Uninstallation
Uninstall oh-my-zsh. This restores .zshrc, but not .tmux.conf or .vimrc
```bash
uninstall_oh_my_zsh
```