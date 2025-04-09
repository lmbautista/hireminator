FROM ruby:3.1.0

RUN apt-get update -o Acquire::AllowInsecureRepositories=true \
  && apt-get install -y --no-install-recommends \
  build-essential \
  libpq-dev \
  curl \
  libxml2-dev \
  libxslt-dev \
  zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

RUN gem install bundler:2.3.11

WORKDIR /app

COPY Gemfile Gemfile.lock ./

ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=true

RUN bundle _2.3.11_ install

RUN bundle exec rake assets:precompile || true

EXPOSE 3000

CMD ["bin/dev"]
