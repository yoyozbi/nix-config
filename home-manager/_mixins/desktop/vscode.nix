{ pkgs, ... }:
{
  programs = {
    vscode = {
      enable = true;
      extensions = with pkgs; [
        vscode-extensions.bradlc.vscode-tailwindcss
        vscode-extensions.eamodio.gitlens
        vscode-extensions.ms-azuretools.vscode-docker
        vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
        vscode-extensions.ms-vscode-remote.remote-containers
        vscode-extensions.github.copilot
        vscode-extensions.github.copilot-chat
        vscode-extensions.tamasfe.even-better-toml
        vscode-extensions.ms-vsliveshare.vsliveshare
        vscode-extensions.christian-kohler.path-intellisense
        vscode-extensions.bmewburn.vscode-intelephense-client
        vscode-extensions.devsense.profiler-php-vscode
        vscode-extensions.esbenp.prettier-vscode
        vscode-extensions.rust-lang.rust-analyzer
        vscode-extensions.bradlc.vscode-tailwindcss
        vscode-extensions.vscodevim.vim
        vscode-extensions.vscode-icons-team.vscode-icons
        vscode-extensions.mkhl.direnv
        vscode-extensions.ms-toolsai.jupyter
        vscode-extensions.yoavbls.pretty-ts-errors
        vscode-extensions.svelte.svelte-vscode
      ];

      mutableExtensionsDir = true;
      package = pkgs.master.vscode;
    };
  };
}
