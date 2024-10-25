Forked from [schollz's fork](https://github.com/schollz/supercollider-radio) of [jpburstrom's fork](https://github.com/jpburstrom/nattradion-docker) of [maxhawkins' sc_radio](https://github.com/maxhawkins/sc_radio)

### build

```cmd
podman build -t oootini/supercollider-radio:latest-arm64 -f Dockerfile --platform linux/arm64
podman push oootini/supercollider-radio:latest-arm64

podman build -t oootini/supercollider-radio:latest-amd64 -f Dockerfile --platform linux/amd64
podman push oootini/supercollider-radio:latest-amd64
```

```cmd
podman build -t oootini/marina-radio:latest-amd64 -f marina.Dockerfile --platform linux/amd64
podman push oootini/marina-radio:latest-amd64

podman build -t oootini/marina-radio:latest-arm64 -f marina.Dockerfile --platform linux/arm64
podman push oootini/marina-radio:latest-arm64
```

```cmd
podman build -t oootini/radio-streamer:latest-amd64 -f streamer.Dockerfile --platform linux/amd64
podman push oootini/radio-streamer:latest-amd64

podman build -t oootini/radio-streamer:latest-arm64 -f streamer.Dockerfile --platform linux/arm64
podman push oootini/radio-streamer:latest-arm64
```

### run

```cmd
podman run -d \
  --name supercollider-radio \
  --network=host \
  --replace \
  oootini/supercollider-radio:latest-arm64
```

```cmd
podman run -d \
  --name marina-radio \
  --network=host \
  --replace \
  oootini/marina-radio:latest-arm64
```

```cmd
podman run -d \
  --name radio-streamer \
  --network=host \
  --replace \
  -e STREAM_FROM="http://localhost:8000/radio.mp3" \
  -e STREAM_TO="http://192.168.1.56:9222/supercollider.mp3?stream=true&advertise=true" \
  oootini/radio-streamer:latest-arm64
```