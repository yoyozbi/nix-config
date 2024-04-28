# My personnal nix-config
This respository hosts my servers and desktops nixos configuration
# Installation (or reinstallation)
## For tiny1 or tiny2
 1. Provision a new instance with ubuntu
 2. Connect via ssh and copy `authorized_keys` to the root user
 3. Login with root user
 4. Run the [nixos-infect](https://github.com/elitak/nixos-infect) script:
 ```bash
 curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-23.05 bash -x
 ```
 5. Connect via the root user and change nix-config partitions uuids by looking at the `hardware-configuration.nix` file
 6. Create a file in `/etc/cachix-agent.token`
 ```
 CACHIX_AGENT_TOKEN=<token>
 ```
 6. Get the new public age key of the server
 ```bash
 nix-shell -p ssh-to-age --run 'ssh-keyscan <ipAdress> | ssh-to-age'
 ```
 7. Change public key of server in `.sops.yaml`
 8. Update keys for secrets
 ```bash
nix-shell -p sops --run "sops updatekeys nixos/_mixins/k3s/ocr-secrets.yml"
 ```
 9. Apply custom nix config over the new node
 ```bash
 nixos-rebuild --target-host root@tiny1 --flake ~/nix-config/.#tiny1 switch
 ```

