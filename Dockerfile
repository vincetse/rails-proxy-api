# Stage 0: Builder
FROM registry.hub.docker.com/library/ruby:3.4.8-slim AS builder

RUN \
  apt-get update -qq && \
  apt-get install -y -qq \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    > /dev/null && \
  echo "gem: --no-rdoc --no-ri" > ~/.gemrc && \
  gem install foreman

WORKDIR /app

# Install gems - use BUNDLE_PATH so we can copy it easily to Stage 1
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && \
    bundle config set --local deployment 'true' && \
    bundle config set --local path 'vendor/bundle' && \
    bundle install

# Copy the rest of the application
COPY . .

# Stage 1: Production runtime
FROM registry.hub.docker.com/library/ruby:3.4.8-slim

RUN \
  apt-get update -qq && \
  apt-get install -y -qq \
    --no-install-recommends \
    libpq-dev \
    > /dev/null && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

WORKDIR /app

# 1. Copy everything from builder with the correct ownership for 'nobody'
# Note: We copy the whole /app folder to ensure bin/, public/, and config.ru exist.
COPY --from=builder --chown=nobody:nogroup /usr/local/bundle /usr/local/bundle
COPY --from=builder --chown=nobody:nogroup /app /app

# 2. Ensure permissions for Rails-writable directories
RUN mkdir -p tmp/pids log storage && \
    chown -R nobody:nogroup tmp log storage

# 3. Setup Environment
ENV \
  RAILS_ENV production \
  RAILS_LOG_TO_STDOUT=true \
  RAILS_SERVE_STATIC_FILES=true \
  PORT 3000

# 4. Switch to non-root user
USER nobody

EXPOSE 3000
CMD foreman run web
