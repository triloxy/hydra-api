# Hydra CI API for Haskell

This project was started as an experiment to build a metric database
for all derivations in hydra.nixos.org but then diverged to a reusable
haskell library.

For example to get project details for "nixos":

~~~ haskell
> getProject "nixos"
Project {displayName = "NixOS", description = "NixOS, the purely functional Linux distribution", releases = ["nixos-16.09pre84182","nixos-1311308"], enabled = True, name = "nixos", owner = "eelco", hidden = False, jobsets = ["staging-small","release-20.03","unstable-small","release-20.03-small","release-18.09","release-17.03","release-16.09","gcc-5","release-18.03-small","release-19.09-small","release-19.09","release-19.03-aarch64","release-18.03-aarch64","release-18.03","release-20.03-aarch64","release-19.03","nixup","glibc-2.19","release-19.09-aarch64","nixos-test-expensive-eval","perl-5.22","release-18.09-small","gnome-3.20","grahamc-i686","trunk-combined","stdenv-updates","unstable-aarch64","boot-order","systemd-217","glibc-2.18","nix-2.0","binutils-2.26","release-14.12","release-15.09-small","master","systemd","staging","release-18.09-aarch64","bash-4.3","modular","xorg-test","release-15.09","release-14.04-small","release-19.03-small","gcc-4.9","kde47-test","systemd-update","glibc-2.20","release-16.03-small","stdenv-test","mariadb-10.2","staging-17.03","release-17.03-small","release-16.09-small","release-14.12-small","patchelf-0.9","release-13.10","openssl-1.1","gcc-8","grsec-stdenv","issue-18312-webkitgtk24-removal","release-17.09-small","release-16.03","gcc-6","closure-size","release-17.09","reproducibility","release-14.04","perl-5.20","gcc-7","keymap-test-debug","rhel6","systemd-227","unstable-small-CVE-2018-15688"]}
~~~

Or get measures:

~~~ haskell
> getBuildTimes "nixos" "release-19.09" "nixpkgs.cabal-install.x86_64-linux"
[Measure {buildId = Just 100903174, timestamp = Just 1568400442, value = Just 117, error = Nothing},Measure {buildId = Just 101222609, timestamp = Just 1568629138, value = Just 212, error = Nothing},Measure {buildId = Just 101222609, timestamp = Just 1568629138, value = Just 5, error = Nothing},Measure {buildId = Just 101222609, timestamp = Just 1568629138, value = Just 61, error = Nothing},Measure {buildId = Just 102775494, timestamp = Just 1570539349, value = Just 150, error = Nothing},Measure {buildId = Just 103435795, timestamp = Just 1571223586, value = Just 154, error = Nothing},Measure {buildId = Just 105022645, timestamp = Just 1572611036, value = Just 134, error = Nothing}]
~~~
