# syntax=docker/dockerfile:1
# Development Dockerfile for docker-compose

ARG RUBY_VERSION=3.2.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libvips \
    postgresql-client \
    build-essential \
    git \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    nodejs \
    npm && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set development environment variables
ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=""

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Create a non-root user for development
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER rails:rails

# Expose port 3000 for Rails server
EXPOSE 3000

# Default command (can be overridden in docker-compose)
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
