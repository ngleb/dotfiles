let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUtfaUy4TqkxrE8TzToJu/lOUZooAPPjeeNWwodZ2o4 root@gnpc"
  ];
in
{
  "proxypwd.age".publicKeys = keys;
  "proxyip.age".publicKeys = keys;
  "ipsec_secrets.age".publicKeys = keys;
  "ipsec_conf.age".publicKeys = keys;
  "options.age".publicKeys = keys;
  "xl2tpd.age".publicKeys = keys;
}
