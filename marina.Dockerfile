# Birth a new radio server
ARG TARGETARCH

FROM oootini/supercollider-radio:latest-${TARGETARCH}

# Update radio.sc
COPY marina.scd radio/radio.scd
COPY *.mp3 /

# Start streaming to broadcast server
# CMD ["sh", "-c", "ffmpeg -i http://localhost:8000/radio.mp3 -c copy -f mp3 http://localhost:9222/sc_radio.mp3"]
CMD ["forego", "start"]