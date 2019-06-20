FROM ruby:2.6.1-alpine

RUN mkdir /usr/src/app && \
    apk update && \
    apk add --virtual .build build-base openssl-dev
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install --path vendor && \
    apk del .build

COPY . .
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0"]
