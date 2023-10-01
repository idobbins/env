if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path /opt/homebrew/bin

fish_add_path /Users/idobbins/.yarn/bin
fish_add_path /Users/idobbins/.cargo/bin
fish_add_path /Users/idobbins/go/bin

fish_add_path /Users/idobbins/.local/bin

fish_add_path /usr/local/smlnj/bin
fish_add_path /opt/homebrew/Cellar/millet/0.12.9/bin

eval (brew shellenv)

# comment out this line if using warp
starship init fish | source

# command aliases
alias finder="open -a Finder ."

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# opam configuration
source /Users/idobbins/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /Users/idobbins/.ghcup/bin $PATH # ghcup-env
alias haskell-language-server="/Users/idobbins/.ghcup/hls/2.2.0.0/lib/haskell-language-server-2.2.0.0/bin/haskell-language-server-9.6.2"