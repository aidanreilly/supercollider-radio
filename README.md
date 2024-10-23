Forked from [schollz's fork](https://github.com/schollz/supercollider-radio) of [jpburstrom's fork](https://github.com/jpburstrom/nattradion-docker) of [maxhawkins' sc_radio](https://github.com/maxhawkins/sc_radio)

### build

```cmd
podman build -t oootini/supercollider-radio:latest-arm64 -f Dockerfile --platform linux/arm64
podman push oootini/supercollider-radio:latest-arm64

podman build -t oootini/supercollider-radio:latest-amd64 -f Dockerfile --platform linux/amd64
podman push oootini/supercollider-radio:latest-amd64
```

```cmd
podman build -t oootini/marina:latest-amd64 -f marina.Dockerfile --platform linux/amd64
podman push oootini/marina:latest-amd64
```

### run

```cmd
podman run -d \
  --name supercollider-radio \
  --network=host \
  --replace \
  oootini/supercollider-radio:latest-amd64
```

```cmd
podman run -d \
  --name marina \
  --network=host \
  --replace \
  oootini/marina:latest-amd64
```

Put your SuperCollider file in a single folder, e.g. `radio` and then run:

```
docker run -v `pwd`/radio:/data -v `pwd`/recordings:/root/.local/share/SuperCollider/Recordings -p 8124:8000 sc
```

you can use this docker image to render SuperCollider files to audio (by recording) or you can listen to as a radio at `localhost:8000/radio.mp3`.
