FROM ruby:2.6.3

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Start the main process.
CMD bundle exec rails s -p ${PORT} -b '0.0.0.0'
