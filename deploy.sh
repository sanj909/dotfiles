#!/bin/bash
set -euo pipefail
USAGE=$(cat <<-END
    Usage: ./deploy.sh [OPTIONS]
    Creates ~/.zshrc and ~/.tmux.conf

    OPTIONS:
        --vim       deploy very simple vimrc config
END
)

export DOT_DIR=$(dirname $(realpath $0))

VIM="false"
while (( "$#" )); do
    case "$1" in
        -h|--help)
            echo "$USAGE" && exit 1 ;;
        --vim)
            VIM="true" && shift ;;
        --) # end argument parsing
            shift && break ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2 && exit 1 ;;
    esac
done

# Tmux setup. Overwrites $HOME/.tmux.conf
echo "source $DOT_DIR/config/tmux.conf" > $HOME/.tmux.conf

# vimrc. Overwrites $HOME/.vimrc
if [[ $VIM == "true" ]]; then
    echo "deploying .vimrc"
    echo "source $DOT_DIR/config/vimrc" > $HOME/.vimrc
fi

# zshrc setup
# ./install.sh copies $HOME/.zshrc to $HOME/.zshrc.pre-oh-my-zsh and overwrites $HOME/.zshrc
# Revert this change and add "source $DOT_DIR/config/zshrc.sh" to $HOME/.zshrc
echo 'autoload -U compinit && compinit -u' > $HOME/.zshrc  # https://console.workbrew.com/documentation/troubleshooting#how-do-i-fix-my-code-zsh-code-completions
cat $HOME/.zshrc.pre-oh-my-zsh >> $HOME/.zshrc
printf "\nsource $DOT_DIR/config/zshrc.sh\n" >> $HOME/.zshrc

zsh
