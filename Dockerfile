FROM ubuntu:18.04
SHELL ["/bin/bash", "-l", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install gnupg2 curl -y

# Install RVM and Ruby 1.9.3
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
RUN curl -sSL https://get.rvm.io | bash -s
RUN /usr/local/rvm/bin/rvm install 1.9.3

# Set appropriate environment variables
ENV GEM_HOME=$HOME/.gem
ENV PATH="/usr/local/rvm/rubies/ruby-1.9.3-p551/bin:${GEM_HOME}/bin:${PATH}"

# Install RubyGems and Bundler
RUN gem install bundler -v 1.17.3

WORKDIR /app
CMD ["ruby"]
