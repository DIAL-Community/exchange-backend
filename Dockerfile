FROM ruby:3.2.2 AS build-web

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update -qq && apt-get install -y cron git imagemagick build-essential libpq-dev nodejs logrotate cmake cloc
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - 
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update
RUN apt-get install -y postgresql-client-14

RUN mkdir /candidates
RUN git clone https://github.com/unicef/publicgoods-candidates.git /candidates

RUN mkdir /products
RUN git clone https://github.com/publicgoods/products.git /products

RUN mkdir /product-evaluation-rubric
RUN git clone https://gitlab.com/dial/product-evaluation-rubric/product-evaluation-rubric.git /product-evaluation-rubric

WORKDIR /tmp
ENV BUNDLER_VERSION 2.4.10
COPY Gemfile /tmp/Gemfile
COPY Gemfile.lock /tmp/Gemfile.lock

RUN gem install rswag-api -v 2.9.0
RUN gem install rswag-specs -v 2.9.0
RUN gem install rswag-ui -v 2.9.0
RUN gem install simple_token_authentication -v 1.18.1
RUN gem install google-cloud-translate -v 3.4.0

RUN gem install bundler
RUN bundle install --jobs 2 --retry 5 --without development

RUN mkdir /t4d
WORKDIR /t4d

COPY . /t4d
