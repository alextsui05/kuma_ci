FROM ubuntu:trusty
#FROM circleci/ruby:2.2.8

RUN sudo apt-get update
RUN sudo apt-get install -y software-properties-common

# Install basic tools for CircleCI
RUN sudo apt-get install -y git openssh-client openssh-server

RUN sudo apt-add-repository -y ppa:rael-gc/rvm
RUN sudo apt-get update
RUN sudo apt-get install -y rvm

# Install java
COPY ./jdk1.8.0_144 /opt/jdk1.8.0_144
ENV PATH="/opt/jdk1.8.0_144/bin:${PATH}"

# Install dependencies
COPY ./circleci /var/tmp/circleci
RUN chmod +x /var/tmp/circleci/*.sh
RUN /var/tmp/circleci/install_elasticsearch.sh
RUN /var/tmp/circleci/install_mecab.sh
RUN /var/tmp/circleci/install_phantomjs.sh
RUN chmod +x /usr/local/bin/phantomjs
RUN sudo apt-get install -y libfontconfig

RUN echo "mysql-server-5.6 mysql-server/root_password password password" | sudo debconf-set-selections
RUN echo "mysql-server-5.6 mysql-server/root_password_again password password" | sudo debconf-set-selections
RUN sudo apt-get install -y mysql-server-5.6
RUN sudo /bin/bash -l -c "cd /etc/mysql && patch -p0 < /var/tmp/circleci/my.cnf.diff"

RUN sudo apt install -y libmysqlclient-dev
RUN sudo apt install -y libcurl4-openssl-dev
RUN sudo apt install -y mongodb
RUN sudo apt install -y imagemagick

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt install -y nodejs

# Install Ruby 2.2.10
RUN /bin/bash -l -c "rvm install 2.4.4"
RUN /bin/bash -l -c "gem install bundler"
RUN echo "source /etc/profile.d/rvm.sh" >> /root/.bashrc

CMD /bin/bash
