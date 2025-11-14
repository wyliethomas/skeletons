# syntax=docker/dockerfile:1
FROM ruby:3.2.0
ARG COMPOSE_NAME=app
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /${COMPOSE_NAME}
COPY Gemfile /${COMPOSE_NAME}/Gemfile
# Copy Gemfile.lock if it exists (optional for skeleton projects)
COPY Gemfile.lock* /${COMPOSE_NAME}/
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
