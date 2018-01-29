FROM ruby:2.3
LABEL maintainer="Andrey Novikov <envek@envek.name>"

ENV RACK_ENV=production PORT=5000
WORKDIR /app

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
  build-essential \
  pgdbf \
  unzip \
  libpq-dev


COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN bundle install --jobs 4 --retry 5

ADD . /app
WORKDIR /app

EXPOSE $PORT

CMD bundle exec rackup -s puma -p $PORT -o 0.0.0.0 -O "Threads=0:${MAX_THREADS:-16}"
