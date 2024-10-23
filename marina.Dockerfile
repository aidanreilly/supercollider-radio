# Birth a new radio server at http://localhost:8000/radio.mp3
ARG TARGETARCH

FROM oootini/supercollider-radio:latest-${TARGETARCH}

# Update radio.sc
COPY marina.scd /radio/radio.scd
COPY *.wav /

# Start streaming
CMD ["forego", "start"]
