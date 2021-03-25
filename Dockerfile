FROM python:3.9-slim-buster

RUN apt update && apt install -y binutils libc6 libglib2.0-0

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

