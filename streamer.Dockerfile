FROM alpine:latest

# Install ffmpeg
RUN apk add --no-cache ffmpeg

FROM alpine:latest

# Install ffmpeg
RUN apk add --no-cache ffmpeg

# Start streaming with retry logic
CMD ["sh", "-c", "until ffmpeg -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 2 -i ${STREAM_FROM} -c copy -f mp3 ${STREAM_TO}; do echo 'Stream dropped. Retrying in 5 seconds...'; sleep 5; done"]
