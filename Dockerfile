FROM python:3.10-slim

RUN apt-get update && \
    apt-get install -y git && \
    pip install mkdocs mkdocs-material

WORKDIR /docs

EXPOSE 8000


CMD ["mkdocs", "serve", "-a", "0.0.0.0:8000"]

