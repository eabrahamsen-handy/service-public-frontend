FROM 591045937678.dkr.ecr.us-east-1.amazonaws.com/official/ruby:2.4.3

MAINTAINER devops@handy.com

RUN apt-get update \
  && apt-get install -y build-essential nodejs locales unzip \
  && wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.0/dumb-init_1.1.0_amd64 \
  && chmod +x /usr/local/bin/dumb-init \
  && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen locale-gen \
  && mkdir -p /u/apps/service

WORKDIR /u/apps/service

# Create tmp pid dir for sidekiqs
RUN mkdir -p /u/apps/service/tmp/pids

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
ADD .ruby-version .ruby-version

ARG ENVIRONMENT=development

ENV RACK_ENV=$ENVIRONMENT \
    RAILS_ENV=$ENVIRONMENT

RUN bundle install

COPY ./ ./
