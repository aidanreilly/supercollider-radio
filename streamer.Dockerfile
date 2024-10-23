FROM alpine:latest

# Install ffmpeg
RUN apk add --no-cache ffmpeg

# Start streaming
CMD ["sh", "-c", "ffmpeg -i ${STREAM_FROM} -c copy -f mp3 ${STREAM_TO}"]
