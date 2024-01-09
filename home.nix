{ config, pkgs, ... }:

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
    nodejs
    yarn
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".screenrc".source = dotfiles/screenrc;
    ".tmux.conf".source = dotfiles/tmux.conf;
    ".vimrc".source = dotfiles/vimrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/gleb/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    GTK_OVERLAY_SCROLLING = "0";
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
    LIBVIRT_DEFAULT_URI = "qemu:///system";
    WORKON_HOME = "$HOME/.virtualenvs";
    PROJECT_HOME = "$HOME/dev";

    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/config";
    NPM_CONFIG_CACHE      = "${config.xdg.cacheHome}/npm";
    NPM_CONFIG_PREFIX     = "${config.xdg.stateHome}/npm";
    NODE_REPL_HISTORY     = "${config.xdg.dataHome}/node/repl_history";
  };

  home.sessionPath = [
    "$(${pkgs.yarn}/bin/yarn global bin)"
  ];

  xdg.configFile."npm/config".text = ''
    userconfig=${config.xdg.configHome}/npm/config
    cache=${config.xdg.cacheHome}/npm
    prefix=${config.xdg.stateHome}/npm
  '';

  # Let Home Manager install and manage itself.
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

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-gtk3;
    extraPackages = epkgs: with epkgs; [
      ag
      avy
      bind-key
      cape
      consult
      corfu
      csv-mode
      deft
      diminish
      docker-compose-mode
      dockerfile-mode
      elfeed
      elpy
      find-file-in-project
      flycheck
      flycheck-ledger
      flyspell-popup
      js2-mode
      langtool
      ledger-mode
      lsp-mode
      lsp-pyright
      lsp-ui
      magit
      marginalia
      markdown-mode
      nginx-mode
      nix-mode
      olivetti
      orderless
      org
      org-contrib
      ox-clip
      ox-pandoc
      smartparens
      smex
      sokoban
      treemacs
      use-package
      vertico
      w32-browser
      web-mode
      which-key
      yasnippet
      zenburn-theme
    ];
  };
}
