# Stage 1: Building Ruby 1.9.3 on Ubuntu 22.04
FROM ubuntu:22.04 AS builder

# Install dependencies needed for Ruby compilation
RUN apt-get update && apt-get install -y build-essential openssl libssl-dev libreadline-dev zlib1g-dev libffi-dev libgdbm-dev libncurses5-dev wget
RUN wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz \
    && tar zxvf openssl-1.0.2u.tar.gz \
    && cd openssl-1.1.1g \
    && ./config --prefix=$HOME/.openssl/openssl-1.0.2u.tar.gz --openssldir=$HOME/.openssl/openssl-1.0.2u.tar.gz \
    && make \
    && make test \
    && make install
    
# Download Ruby 1.9.3 source code and compile
RUN wget https://cache.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p551.tar.gz \
    && tar -xzvf ruby-1.9.3-p551.tar.gz \
    && cd ruby-1.9.3-p551 \
    && ./configure --prefix=/usr/local/ruby-1.9.3 --with-openssl-dir=$HOME/.openssl/openssl-1.0.2u.tar.gz \
    && make \
    && make install



# Stage 2: Final image with Ruby 1.9.3 on Ubuntu 22.04
FROM ubuntu:22.04

# Install necessary packages for the final image
RUN apt-get update && apt-get install -y gnupg2 curl

# Setup the Ubuntu keyring for apt
RUN install -m 0755 -d /etc/apt/keyrings && curl -fsSL http://security.ubuntu.com/ubuntu/ubuntu/project/ubuntu-archive-keyring.gpg | gpg --dearmor > /usr/share/keyrings/ubuntu.gpg && chmod a+r /usr/share/keyrings/ubuntu.gpg

# Copy the compiled Ruby 1.9.3 from the previous stage
COPY --from=builder /usr/local/ruby-1.9.3 /usr/local/ruby-1.9.3
COPY --from=builder /root/.openssl/openssl-1.0.2u.tar.gz /root/.openssl/openssl-1.0.2u.tar.gz

# Add Ruby 1.9.3 to the PATH to run it globally
ENV PATH="/usr/local/ruby-1.9.3/bin:${PATH}"

# Additionally, we can set Ruby 1.9.3 as the default version, but we recommend using newer versions of Ruby.
RUN ln -s /usr/local/ruby-1.9.3/bin/ruby /usr/local/bin/ruby \
    && ln -s /usr/local/ruby-1.9.3/bin/gem /usr/local/bin/gem \
    && ln -s /etc/ssl/certs ~/.openssl/openssl-1.1.1g/certs

# Set the working directory for the image
WORKDIR /app

# Install and update Rubygems and Bundler for Ruby 1.9.3
RUN gem install rubygems-update -v 2.7.8
RUN update_rubygems
RUN gem install bundler -v 1.17.3

# Run the script when the container is launched
CMD ["ruby"]
