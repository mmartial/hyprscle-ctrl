# Hyprspace.io Controller

A simple container to create an hyprspace.io subnet, easily configure it and allow the use of iptables to prevent select which local services to authorized access to.

Requires manual setup of other peers and port blocking, as default is to authorize everything.

## Notes

The private network's `address` is set as `10.12.13.0/24` to use a likely unused network in your setup. If it is used, change it.

## Building

### On hs0

(ie the server whose ID we will copy over the other hosts)

Do not modify `config.yml`'s information unless you want to change `listen_port` or the private network's `address`.

Build the container:
```
docker build --tag hsc:local .
```

Start it in interactive mode (no network permissions) so we can `docker ps` and `docker cp` the generated configuration file:
```
docker run -it hsc:local
```

In another terminal (`tmux`) `docker ps` to get the `CONTAINER ID` then 
```
docker cp <CONTAINERID>:/etc/hyprspace/hs.yaml hs0.yaml
```

You can `docker kill` or `Ctrl+C` the running container.

By doing this we extracted a configuration file we can extend at will.

We can now run it in production mode:
```
docker run --network host --cap-add=NET_ADMIN -v /dev/net/tun:/dev/net/tun -v `pwd`/hs0.yaml:/etc/hyprspace/hs.yaml  hsc:local
```

When you run it this time, it will have seen the configuration file present and not generated a new one.

After a few seconds, you will see
```
[+] Network Setup Complete...Waiting on Node Discovery
[+] Successfully Created Hyprspace Daemon
```

## On hs1

Before building the container for any other host, edit the `config.yml`:
- Give your new `hs` device a different `address` (ex: `10.12.13.11/24`)
- enter the peer configuration so that you can talk to `hs0`
    - copy the `id:` entry from `hs0`
    - extend the `config.yml` with proper YAML content:
```
peers:
  10.12.13.1:
    id: copied_id_of_hs0
```
- similar to `hs0`: `docker build --tag hsc:local .`
- similar to `hs0`: `docker run -it hsc:local`
- similar to `hs0`: `docker cp <CONTAINERID>:/etc/hyprspace/hs.yaml hs1.yaml` (here we name it `hs1.yaml` to keep an easier way to separate IDs)
- kill it 
- Start the main run
```
docker run --network host --cap-add=NET_ADMIN -v /dev/net/tun:/dev/net/tun -v `pwd`/hs1.yaml:/etc/hyprspace/hs.yaml  hsc:local
```
