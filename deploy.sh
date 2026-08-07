#!/bin/bash
set -euo pipefail
USAGE=$(cat <<-END
    Usage: ./deploy.sh [OPTIONS]
    Creates ~/.zshrc and ~/.tmux.conf

    OPTIONS:
        --vim       deploy very simple vimrc config
        --vscode    deploy VS Code settings and extensions
END
)

export DOT_DIR=$(dirname $(realpath $0))

VIM="false"
VSCODE="false"
while (( "$#" )); do
    case "$1" in
        -h|--help)
            echo "$USAGE" && exit 1 ;;
        --vim)
            VIM="true" && shift ;;
        --vscode)
            VSCODE="true" && shift ;;
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

# VS Code user settings and extensions
if [[ $VSCODE == "true" ]]; then
    echo "deploying VS Code settings and extensions"
    command -v jq >/dev/null || { echo "jq is required to install VS Code extensions" >&2; exit 1; }
    command -v code >/dev/null || { echo "VS Code's code command is required to install extensions" >&2; exit 1; }

    vscode_user_dir="$HOME/Library/Application Support/Code/User"
    mkdir -p "$vscode_user_dir"
    vscode_settings_path="$vscode_user_dir/settings.json"
    vscode_settings_backup_path="$vscode_user_dir/settings_pre_dotfiles.json"
    if [[ -L "$vscode_settings_path" ]]; then
        :
    elif [[ -f "$vscode_settings_path" ]]; then
        if [[ -e "$vscode_settings_backup_path" || -L "$vscode_settings_backup_path" ]]; then
            echo "Cannot back up VS Code settings: $vscode_settings_backup_path already exists" >&2
            exit 1
        fi
        echo "backing up VS Code settings to $vscode_settings_backup_path"
        mv "$vscode_settings_path" "$vscode_settings_backup_path"
    elif [[ -e "$vscode_settings_path" ]]; then
        echo "Cannot replace VS Code settings: $vscode_settings_path is not a file or symlink" >&2
        exit 1
    fi
    ln -sfn "$DOT_DIR/vscode/settings.json" "$vscode_settings_path"

    jq -r '.recommendations[]' "$DOT_DIR/vscode/extensions.json" \
        | xargs -n 1 code --install-extension
fi

zsh
