# TODO: Использовать рядовой юзер вместо рута

FROM docker.io/library/ruby:3.4.2-slim

# Rails app lives here
WORKDIR /app

# Install base packages
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libyaml-dev

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
