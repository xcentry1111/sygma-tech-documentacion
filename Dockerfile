FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1

RUN pip install --no-cache-dir mkdocs mkdocs-material

WORKDIR /docs

EXPOSE 8000

CMD ["mkdocs", "serve", "-a", "0.0.0.0:8000"]
