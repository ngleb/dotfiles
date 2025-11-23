{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth = {
    enable = true;
  };
  hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  };

  age.secrets = {
    proxyip.file = ./secrets/proxyip.age;
    proxypwd.file = ./secrets/proxypwd.age;
    ipsec_secrets.file = ./secrets/ipsec_secrets.age;
    ipsec_conf.file = ./secrets/ipsec_conf.age;
    options.file = ./secrets/options.age;
    xl2tpd.file = ./secrets/xl2tpd.age;
  };

  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  time.timeZone = "Asia/Tomsk";

  networking = {
    hostName = "gnpc";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        5357 # wsdd
        8083
        61831
        61832
        1081
        8080
        1080
        8082
      ];
      allowedUDPPorts = [
        3702 # wsdd
        8083
        61831
        61832
        1081
        8080
        1080
        8082
      ];
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  virtualisation.docker.enable = true;
  virtualisation.docker.extraPackages = with pkgs; [
    docker-compose
  ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;

  fileSystems = {
    "/media/data" = {
      device = "/dev/disk/by-uuid/9baee153-7402-4050-90ec-250e369534a0";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/media/passport" = {
      device = "/dev/disk/by-uuid/526EDBA46EDB7EE3";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" "gid=1000" "dmask=0002" "fmask=0113" "windows_names" ];
    };
    "/media/media" = {
      device = "//192.168.1.2/Media";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets,file_mode=0644,dir_mode=0755,uid=1000,gid=1000"];
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_CTYPE="en_IE.UTF-8";
      LC_NUMERIC="en_IE.UTF-8";
      LC_TIME="en_IE.UTF-8";
      LC_COLLATE="C.UTF-8";
      LC_MONETARY="en_US.UTF-8";
      LC_MESSAGES="en_US.UTF-8";
      LC_PAPER="en_IE.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME="qt5ct";
    PLAYWRIGHT_BROWSERS_PATH = pkgs.playwright-driver.browsers;
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS="true";
  };

  environment.localBinInPath = true;

  environment.shellAliases = {
    la = "ll -A";
  };

  security.rtkit.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ splix samsung-unified-linux-driver_1_00_37 ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.blueman.enable = true;

  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "grp:caps_select,compose:ralt";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.xfce.enable = false;
  services.libinput.enable = true;

  services.locate = {
    enable = true;
    package = pkgs.mlocate;
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.tor = {
    enable = true;
    client.enable = true;
    settings = {
      UseBridges = true;
      ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/lyrebird";
      Bridge = [
        "obfs4 141.144.242.150:443 259D40B5345BD8ED89309E065022FFB37A6F0368 cert=HsYMGKItPlon6pz4Iw0Dx595x60b7z3V3fJ8iCas0ie813t7HIvZ/SsDyqsuZosJkAaacg iat-mode=0"
        "obfs4 77.57.57.222:9003 FB3C9523017BE03DA622A71D98AF0E6AAEE676B8 cert=2SnJpsZdzUpEdEt0CcaTflaUpPYJd7qYPHVSI8DUfKmdLJ1i40I6H5PQjobBfuRWWVM5NA iat-mode=0"
      ];
    };
  };

  services.zapret = {
    enable = false;
    params = [
      "--dpi-desync=fake"
      "--dpi-desync-ttl=3"
    ];
    whitelist = [
      "youtube.com"
      "googlevideo.com"
      "ytimg.com"
      "youtu.be"
      "linkedin.com"
    ];
  };

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.samba-wsdd.enable = true;
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "gnpc";
        "netbios name" = "gnpc";
        security = "user";
        "hosts allow" = "192.168.1. 192.168.122. 127.0.0.1 localhost";
        "map to guest" = "bad user";
      };
      Movies = {
        path = "/media/data/Movies";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "gleb";
        "force group" = "users";
      };
      Data = {
        path = "/media/data";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "gleb";
        "force group" = "users";
      };
      Passport = {
        path = "/media/passport";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "gleb";
        "force group" = "users";
      };
      Public = {
        path = "/home/gleb/public";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "gleb";
        "force group" = "users";
      };
    };
  };

  users.users.gleb = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "lp" "wireshark" "adbusers" "libvirtd" "vboxusers" "docker" "ydotool" ];
  };

  fonts.packages = with pkgs; [
    fira
    fira-code
    fira-code-symbols
    ibm-plex
    inconsolata
    jetbrains-mono
    liberation_ttf
    meslo-lg
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    noto-fonts-color-emoji
    noto-fonts-extra
    source-code-pro
    source-sans
    source-serif
    symbola
  ];

  programs.bash = {
    completion.enable = true;
    promptInit =
      ''
      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        ((UID)) && PROMPT_COLOR="1;32m"
        if [ -n "$INSIDE_EMACS" ] || [ "$TERM" = "eterm" ] || [ "$TERM" = "eterm-color" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1="\[\033[$PROMPT_COLOR\]\u@\h:\[\033[1;34m\]\w\[\033[0m\]$ "
        else
          PS1="\[\033[$PROMPT_COLOR\]\[\e]0;\u@\h:\w\a\]\u@\h:\[\033[1;34m\]\w\[\033[0m\]$ "
        fi
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
      '';
  };
  programs.adb.enable = true;
  programs.firefox.enable = true;
  programs.firefox.languagePacks = [ "en-US" ];
  programs.git.enable = true;
  programs.seahorse.enable = true;
  programs.tmux.enable = true;
  programs.wireshark.enable = true;
  programs.ydotool.enable = true;
  programs.vim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.vim-full;
  };
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  programs.file-roller.enable = true;
  programs.gnupg.agent.enable = true;
  programs.htop.enable = true;

  programs.steam.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = (with pkgs; [
    (deadbeef-with-plugins.override {
      plugins = with pkgs; [ (callPackage ./deadbeef-fb.nix {}) ];
    })
    (python312.withPackages(ps: with ps; [
      autopep8
      black
      debugpy
      flake8
      jedi
      ipython
      ledger
      pandas
      pip
      playwright
      pyflakes
      pylint
      pyqt5
      pyqt6
      pytest-playwright
      pytest_7
      python-lsp-server
      requests
      rope
      yapf
    ]))
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        jnoortheen.nix-ide
        mkhl.direnv
        ms-azuretools.vscode-docker
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-pylance
        ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        vscode-icons-team.vscode-icons
      ];
    })
    (llama-cpp.override {
      vulkanSupport = true;
    })
    qt6.qtwayland
    playwright-driver
    adwaita-qt
    adwaita-qt6
    aegisub
    allure
    anydesk
    aria2
    bruno
    calibre
    cifs-utils
    clinfo
    curl
    darktable
    dbeaver-bin
    desktop-file-utils
    dig
    element-desktop
    elementary-xfce-icon-theme
    emacs-pgtk
    ffmpeg
    file
    findutils
    flameshot
    freecad
    freerdp
    gajim
    galculator
    gcc
    gimp
    git
    gnome-mahjongg
    gnome-tweaks
    gnumake
    gnupg
    go
    goldendict-ng
    google-chrome
    greybird
    hexchat
    hugo
    hunspell
    hunspellDicts.en-us
    hunspellDicts.ru-ru
    imagemagickBig
    inkscape
    inputs.agenix.packages.x86_64-linux.default
    jetbrains.pycharm-community-bin
    keepassxc
    languagetool
    ledger
    libreoffice-fresh
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugins
    lm_sensors
    lmstudio
    lsof
    mc
    mediainfo
    mediainfo-gui
    mkvtoolnix
    mlocate
    mpv
    nextcloud-client
    nix-bash-completions
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodejs
    nomacs
    nvd
    obs-studio
    pandoc
    parted
    pavucontrol
    pdftk
    psmisc
    qalculate-gtk
    qbittorrent
    qpdf
    qpdfview
    qt6Packages.qt6gtk2
    radeontop
    rename
    ripgrep
    rocmPackages.rocminfo
    sakura
    signal-desktop
    smartmontools
    speedtest-cli
    telegram-desktop
    thunderbird
    tor-browser
    transmission_4-gtk
    tree
    unar
    unzipNLS
    usbutils
    vanilla-dmz
    vlc
    wget
    wineWowPackages.stable
    winetricks
    wireshark
    wmctrl
    wol
    wxhexeditor
    xdg-utils
    yt-dlp
    zathura
    spoofdpi
  ]) ++ (with pkgs.gnomeExtensions; [
    advanced-weather-companion
    appindicator
    dash-to-panel
    auto-move-windows
    run-or-raise
    just-perfection
  ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

