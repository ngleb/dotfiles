{inputs, ...}: {
  additions = final: prev: import ../pkgs final.pkgs;

  modifications = final: prev: {  };

  # New overlay for unstable packages
  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.system;
      config.allowUnfree = true; # Allows unfree packages from unstable
    };
  };
}
