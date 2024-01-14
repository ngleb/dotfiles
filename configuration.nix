{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
    "xpdf-4.04"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth = {
    enable = true;
   };

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  age.secrets = {
    proxyip.file = ./secrets/proxyip.age;
    proxypwd.file = ./secrets/proxypwd.age;
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
        61831
        61832
      ];
      allowedUDPPorts = [
        3702 # wsdd
        61831
        61832
      ];
    };
  };

  fileSystems = {
    "/media/data" = {
      device = "/dev/disk/by-uuid/9baee153-7402-4050-90ec-250e369534a0";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/media/passport" = {
      device = "/dev/disk/by-uuid/526EDBA46EDB7EE3";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" "gid=100" "dmask=0002" "fmask=0113" "windows_names" ];
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
  };

  environment.shellAliases = {
    la = "ll -A";
  };

  security.rtkit.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ splix ];
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

  services.xserver = {
    enable = true;
    layout = "us,ru";
    xkbOptions = "grp:caps_select,compose:ralt";
    libinput.enable = true;
    desktopManager.xfce.enable = true;
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
      ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
      Bridge = "obfs4 159.69.144.204:9004 BCF68B43F4EBE143EE8025CF6A823A99B5F17C72 cert=OrSHk5li167HyyAYYL8/xtatFfRUvY2jiOVFnJxxxkfIiZ0Qlc5MaO5K5dNOqWghkj/wFQ iat-mode=0";
    };
  };

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.samba-wsdd.enable = true;
  services.samba = {
    enable = true;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = gnpc
      netbios name = gnpc
      security = user
      hosts allow = 192.168.1. 127.0.0.1 localhost
      map to guest = bad user
    '';
    shares = {
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

  systemd.services.shadowsocks-client = {
    description = "Shadowsocks client service";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ shadowsocks-libev ];
    script = ''
      exec ss-local \
        -s ''$(cat ${config.age.secrets."proxyip".path}) \
        -p 8388 \
        -b 0.0.0.0 \
        -l 1080 \
        -k ''$(cat ${config.age.secrets."proxypwd".path}) \
        -m chacha20-ietf-poly1305 \
        -a nobody
    '';
  };

  users.users.gleb = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "lp" "wireshark" "adbusers" ];
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
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    source-code-pro
    source-sans
    source-serif
    symbola
  ];

  programs.bash = {
    enableCompletion = true;
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
  programs.wireshark.enable = true;
  programs.firefox.enable = true;
  programs.firefox.languagePacks = [ "en-US" ];
  programs.seahorse.enable = true;
  programs.git.enable = true;
  programs.adb.enable = true;
  programs.tmux.enable = true;
  programs.vim.defaultEditor = true;
  programs.vim.package = pkgs.vim-full;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.file-roller.enable = true;
  programs.gnupg.agent.enable = true;
  programs.htop.enable = true;

  programs.steam.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    (deadbeef-with-plugins.override {
      plugins = with pkgs; [ deadbeefPlugins.lyricbar (callPackage ./deadbeef-fb.nix {}) ];
    })
    emacs29-gtk3
    inputs.agenix.packages.x86_64-linux.default
    git
    aegisub
    anydesk
    calibre
    curl
    darktable
    dbeaver
    desktop-file-utils
    dig
    direnv
    element-desktop
    elementary-xfce-icon-theme
    ffmpeg
    tor-browser
    flameshot
    freerdp
    gajim
    galculator
    gimp
    gnome.gnome-mahjongg
    gnupg
    goldendict
    google-chrome
    greybird
    hexchat
    hunspell
    hunspellDicts.en-us
    hunspellDicts.ru-ru
    inkscape
    keepassxc
    languagetool
    ledger
    libreoffice-fresh
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugins
    mc
    mediainfo
    mediainfo-gui
    mkvtoolnix
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
    pavucontrol
    python3
    qalculate-gtk
    qbittorrent
    qpdfview
    remmina
    rename
    ripgrep
    sakura
    shadowsocks-libev
    signal-desktop
    skypeforlinux
    strongswan
    telegram-desktop
    thunderbird
    transmission_4-gtk
    unar
    usbutils
    vanilla-dmz
    vlc
    wget
    wmctrl
    wol
    wxhexeditor
    xdg-utils
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-weather-plugin
    xfce.xfce4-xkb-plugin
    xpdf
    yt-dlp
    zathura
  ];

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

