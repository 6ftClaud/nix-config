#home-manager/dotfiles.nix
{ ... }:

{

  home.file = {
    ".local/share/oh-my-zsh/themes/claud.zsh-theme" = {
      source = ./configs/zsh/claud.zsh-theme;
    };
    ".zprofile" = {
      source = ./configs/profile/zprofile;
    };
  };
}
