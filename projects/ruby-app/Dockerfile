FROM ruby:2.3.1-alpine

LABEL maintainer "Alex Ruiz - ahharu@ahharu.com"

EXPOSE 4567

COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
    gem install bundler --no-ri --no-rdoc && \
    cd /app ; bundle install --without development test && \
    apk del build-dependencies

COPY . /app
RUN chown -R nobody:nogroup /app
USER nobody

ENV RACK_ENV production

WORKDIR /app

CMD [ "./hello-world.rb" ]

