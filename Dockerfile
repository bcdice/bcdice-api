FROM ruby:3.3-alpine

COPY . bcdice-api/
WORKDIR bcdice-api

RUN apk --no-cache add --virtual .builddeps build-base \
 && bundle config set without development test \
 && bundle install \
 && rm -rf /usr/local/bundle/cache/*.gem \
 && apk del .builddeps

ENV APP_ENV production
EXPOSE 9292
CMD ["bundle", "exec", "rackup", "-E", "deployment"]