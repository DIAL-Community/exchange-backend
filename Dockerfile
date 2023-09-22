FROM ruby:3.2.2 AS build-web

RUN apt-get update
RUN apt-get install -y ca-certificates curl gnupg lsb-release

RUN sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-client-15

ENV NODE_MAJOR=18
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN sh -c 'echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list'
RUN apt-get update
RUN apt-get install -y nodejs

RUN apt-get update
RUN apt-get install -y cron git imagemagick build-essential libpq-dev nodejs logrotate cmake cloc

RUN mkdir /candidates
RUN git clone https://github.com/unicef/publicgoods-candidates.git /candidates

RUN mkdir /products
RUN git clone https://github.com/publicgoods/products.git /products

RUN mkdir /product-evaluation-rubric
RUN git clone https://gitlab.com/dial/product-evaluation-rubric/product-evaluation-rubric.git /product-evaluation-rubric

WORKDIR /tmp
ENV BUNDLER_VERSION 2.4.17
COPY Gemfile /tmp/Gemfile
COPY Gemfile.lock /tmp/Gemfile.lock

RUN gem install rswag-api -v 2.9.0
RUN gem install rswag-specs -v 2.9.0
RUN gem install rswag-ui -v 2.9.0
RUN gem install simple_token_authentication -v 1.18.1
RUN gem install google-cloud-translate -v 3.4.0

RUN gem install bundler
RUN bundle install --jobs 2 --retry 5

RUN mkdir /t4d
WORKDIR /t4d

COPY . /t4d

FROM ruby:3.2.2 AS build-web2

RUN apt-get update
RUN apt-get install -y ca-certificates curl gnupg lsb-release

RUN sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-client-15

ENV NODE_MAJOR=18
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN sh -c 'echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list'
RUN apt-get update
RUN apt-get install -y nodejs

RUN apt-get update
RUN apt-get install -y cron git imagemagick build-essential libpq-dev nodejs logrotate cmake cloc

RUN mkdir /candidates
RUN git clone https://github.com/unicef/publicgoods-candidates.git /candidates

RUN mkdir /products
RUN git clone https://github.com/publicgoods/products.git /products

RUN mkdir /product-evaluation-rubric
RUN git clone https://gitlab.com/dial/product-evaluation-rubric/product-evaluation-rubric.git /product-evaluation-rubric

WORKDIR /tmp
ENV BUNDLER_VERSION 2.4.17
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
