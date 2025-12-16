FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Instala mkdocs + material + plugins útiles para desarrollo
RUN pip install --no-cache-dir \
    mkdocs \
    mkdocs-material \
    mkdocs-glightbox \
    mkdocs-git-revision-date-localized-plugin \
    mkdocs-minify-plugin

WORKDIR /docs

EXPOSE 8000

# En desarrollo usamos el comando del compose, pero dejamos uno por defecto
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000", "--livereload"]