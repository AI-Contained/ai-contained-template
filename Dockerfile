ARG BASE_IMAGE=python:3.12-alpine
FROM ${BASE_IMAGE}

# This should match the same WORKDIR as in the ai-contained-agent-*
#  otherwise AI get's confused
WORKDIR /ai_contained

COPY . .

RUN pip install --no-cache-dir .

ENV ADDRESS=0.0.0.0
ENV PORT=8080


USER 65533:65533

HEALTHCHECK --interval=5s --timeout=3s --start-period=2s --retries=3 \
  CMD python3 -c "import urllib.request, os; urllib.request.urlopen('http://' + os.environ['ADDRESS'] + ':' + os.environ['PORT'] + '/health')"

CMD ["sh", "-c", "exec fastmcp run server.py --transport http --host ${ADDRESS} --port ${PORT} --no-banner"]
