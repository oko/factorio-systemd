# Factorio `systemd` Support

This repository contains files needed to set up multi-instance Factorio servers running under systemd.

## Quickstart

1. Clone:

    ```
    $ git clone https://github.com/oko/factorio-systemd
    ```
2. Install files:
    ```
    $ cd factorio-systemd
    $ sudo make install
    ```
3. Initialize a Factorio game:
    ```
    $ sudo factorio-init myserver
    <...various script output...>
    Next steps:
      1. Edit /etc/factorio/test2/config.ini to tweak server network config
      2. Edit /etc/factorio/test2/server-settings.json to tweak server game config
      3. Edit /etc/factorio/test2/map-gen-settings.json to tweak server mapgen config
      4. Enable server with 'systemctl start factorio@test2'
      5. Start server with 'systemctl start factorio@test2'
    ```
4. Tweak configuration and enable/start the server as explained by `factorio-init`
5. If you need to reset the game, use `factorio-reset` (which stops the server, removes the game file, and restarts the server to let `factorio-init@$instance.service` recreate it)

## How Factorio Runs

Each instance `$instance` runs under its own systemd service named `factorio@$instance.service`, in the following environment:

1. Each instance has its own config directory under `/etc/factorio/$instance`
2. Each instance has its own data directory under `/var/lib/factorio/$instance`
3. All instances run as the `factorio` user (created automatically by `factorio-init@$instance.service` if necessary)
4. All instances run sandboxed with `ProtectSystem=strict` and `ProtectHome=yes`
5. All instances run with read-write access to their *own* data directory only
