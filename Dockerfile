# Use an official Python runtime as a parent image
FROM python:3.7
LABEL maintainer="hello@wagtail.io"

# Set environment varibles
ENV PYTHONUNBUFFERED 1

RUN apt-get update -y && apt-get install -y libenchant-dev

RUN mkdir -p /code/requirements
COPY ./bakerydemo/requirements/base.txt /code/requirements/base.txt
COPY ./bakerydemo/requirements/production.txt /code/requirements/production.txt

RUN pip install --upgrade pip
RUN pip install -r /code/requirements/production.txt
