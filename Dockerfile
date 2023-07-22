FROM ubuntu:18.04
SHELL ["/bin/bash", "-l", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies and Cron
RUN apt update && apt install gnupg2 curl cron -y

# Install RVM and Ruby 1.9.3
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
RUN curl -sSL https://get.rvm.io | bash -s
RUN /usr/local/rvm/bin/rvm install 1.9.3

# Set appropriate environment variables
ENV GEM_HOME=/home/rubyapp/.gem
ENV PATH="/usr/local/rvm/rubies/ruby-1.9.3-p551/bin:${GEM_HOME}/bin:${PATH}"

# Create a non-root user named "rubyapp" and set it as the default user
RUN useradd -ms /bin/bash rubyapp

# Create the home directory and set proper ownership
RUN mkdir -p $GEM_HOME && chown -R rubyapp:rubyapp $GEM_HOME

USER rubyapp

# Install RubyGems and Bundler (as non-root user)
RUN gem install rubygems-update -v 2.7.8
RUN gem install bundler -v 1.17.3

# Start the Cron service
CMD ["cron", "-f"]

WORKDIR /app
CMD ["ruby"]
