ARG BASE_IMAGE=python:3.12-alpine
FROM ${BASE_IMAGE}

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir .

ENV ADDRESS=0.0.0.0
ENV PORT=8080


USER 65533:65533

CMD ["sh", "-c", "exec fastmcp run server.py --transport http --host ${ADDRESS} --port ${PORT} --no-banner"]
