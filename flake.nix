{
  description = "Unified development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: 
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    
    commonPackages = with pkgs; [
      # Development tools
      cmake
      ripgrep

      # Languages and tooling
      python3
      poetry
      black
      rustc
      cargo
      rust-analyzer

      # Dependencies for neovim plugins
      nodejs # Required for some LSP servers
      git # For lazy.nvim
      
      # Language Servers
      bash-language-server
      clang-tools # Provides clangd
      cmake-language-server
      omnisharp-roslyn # C# language server
      haskell-language-server
      pyright
      rust-analyzer
      typescript-language-server
      terraform-ls
      lua-language-server
      
      # Tree-sitter dependencies
      tree-sitter
      
      # Additional tools needed by plugins
      lazygit # For lazygit.nvim
      fzf # For telescope-fzf-native
      
      # Build dependencies
      gcc
      gnumake
      
      # Mason dependencies
      wget
      unzip
      gzip
    ];
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = commonPackages;
      
      # Add SDKROOT environment variable
      shellHook = ''
        export SDKROOT="${pkgs.darwin.apple_sdk.sdk}"
      '';
    };

    homeConfigurations."idobbins" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      
      modules = [{
        home = {
          username = "idobbins";
          homeDirectory = "/Users/idobbins";
          packages = commonPackages;
          stateVersion = "23.11";
          
          # Add necessary environment variables
          sessionVariables = {
            SDKROOT = "${pkgs.darwin.apple_sdk.sdk}";
          };
        };
        
        programs.home-manager.enable = true;

        programs.neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          defaultEditor = true;
          extraLuaConfig = ''
            ${builtins.readFile ./nvim/init.lua}
          '';
        };
      }];
    };
  };
}
