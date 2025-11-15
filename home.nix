{ config, pkgs, outputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "gleb";
  home.homeDirectory = "/home/gleb";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    languagetool
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".screenrc".source = dotfiles/screenrc;
    ".tmux.conf".source = dotfiles/tmux.conf;
    ".vimrc".source = dotfiles/vimrc;
    ".config/sakura/sakura.conf".source = dotfiles/sakura.conf;
    ".config/zathura/zathurarc".source = dotfiles/zathurarc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".npmrc".text = ''
      prefix=${config.home.homeDirectory}/.npm-packages
    '';
  };

  home.sessionVariables = {
    GTK_OVERLAY_SCROLLING = "0";
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
    LIBVIRT_DEFAULT_URI = "qemu:///system";
    PATH = "$HOME/.npm-packages/bin:$PATH";
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
      '';
  };

  home.shellAliases = {
    grep = "grep --color=auto";
    fgrep = "fgrep --color=auto";
    egrep = "egrep --color=auto";
    e = "emacsclient -n";
    ".." = "cd ..";
    "..." = "cd ../..";
    hist = "history | grep $1";      # requires an argument
    ls = "ls -hF --group-directories-first --color=auto";
    lr = "ls -R";                    # recursive ls
    ll = "ls -l";
    la = "ll -A";
    lx = "ll -BX";                   # sort by extension
    lz = "ll -rS";                   # sort by size
    lt = "ll -rt";                   # sort by date
    lm = "la | more";
    mpvp = "mpv --ao=pulse";
    mpvn = "mpv --profile=norm";
    yt = "yt-dlp";
  };

  systemd.user.services = {
    spoofdpi = {
      Unit = {
        Description = "SpoofDPI service";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.spoofdpi}/bin/spoofdpi -enable-doh -addr 0.0.0.0 -dns-addr 8.8.8.8 -window-size 0";
      };
    };
  };

  systemd.user.startServices = "sd-switch";
}
