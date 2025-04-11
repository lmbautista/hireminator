FROM ruby:3.1.0

# Instalar Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Instalar y configurar Corepack
RUN corepack enable && \
    corepack prepare yarn@4.9.1 --activate

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libxml2-dev \
  libxslt1-dev \
  zlib1g-dev \
  pkg-config \
  git \
  curl \
  libvips-dev

ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=true

WORKDIR /app

RUN gem install bundler:2.3.11
COPY Gemfile .
COPY Gemfile.lock .
COPY package.json .
COPY yarn.lock .

RUN bundle _2.3.11_ install
RUN yarn install

COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
