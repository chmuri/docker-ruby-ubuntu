FROM ubuntu:18.04
SHELL [ "/bin/bash", "-l", "-c" ]
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install gnupg2 curl -y 
#RUN gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
RUN curl -sSL https://get.rvm.io | bash -s
RUN  /usr/local/rvm/bin/rvm install 1.9.3
ENV GEM_HOME=$HOME/.gem
ENV PATH="/usr/local/rvm/rubies/ruby-1.9.3-p551/bin:${PATH}"
RUN ln -s /usr/local/rvm/rubies/ruby-1.9.3-p551/bin/ruby /usr/local/bin/ruby \
    && ln -s /usr/local/rvm/rubies/ruby-1.9.3-p551/bin/gem /usr/local/bin/gem \
    && ln -s /usr/local/rvm/rubies/ruby-1.9.3-p551/bin/bundle /usr/local/bin/bundle
RUN gem install rubygems-update -v 2.7.8
#RUN /usr/local/rvm/rubies/ruby-1.9.3-p551/bin/update_rubygems
RUN gem install bundler -v 1.17.3
WORKDIR /app
CMD ["ruby"]
