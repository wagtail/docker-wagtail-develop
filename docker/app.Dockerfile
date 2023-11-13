# syntax=docker/dockerfile:1
ARG PYTHON_VERSION=3.12.0
FROM python:${PYTHON_VERSION}-slim-bookworm as base

LABEL maintainer="hello@wagtail.org"

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

RUN apt-get update -y && apt-get install -y \
    dumb-init \
    libenchant-2-dev \
    postgresql-client

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

WORKDIR /code/

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.cache/pip to speed up subsequent builds.
# Leverage a bind mount to requirements.txt to avoid having to copy them into
# into this layer.
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements,target=/code/requirements \
    --mount=type=bind,source=libs,target=/code/libs,rw \
    --mount=type=bind,source=wagtail,target=/code/wagtail,rw \
    python -m pip install --cache-dir=/root/.cache/pip -U pip \
    && python -m pip install --cache-dir=/root/.cache/pip -r /code/requirements/development.txt

# Switch to the non-privileged user to run the application.
USER appuser

WORKDIR /code/bakerydemo

# Expose the port that the application listens on.
EXPOSE 8000

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Run the application.
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
