FROM ruby:3.1.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl postgresql-client
RUN gem install bundler:2.3.11

WORKDIR /app

COPY Gemfile ./

RUN bundle lock --add-platform x86_64-linux

COPY Gemfile.lock ./
RUN bundle _2.3.11_ install

COPY . .

RUN bundle exec rake assets:precompile || true

EXPOSE 3000

CMD ["bin/dev"]
