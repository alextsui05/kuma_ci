FROM ubuntu:bionic

RUN apt update
RUN apt install -y software-properties-common sudo

RUN sudo apt install -y openssh-client openssh-server
RUN sudo apt install -y patch
RUN sudo apt install -y git
RUN sudo apt install -y curl
RUN sudo apt install -y libfontconfig
RUN sudo apt install -y libcurl4-openssl-dev
RUN sudo apt install -y imagemagick
RUN sudo apt install -y ffmpeg

# Install mysql 8
env DEBIAN_FRONTEND="noninteractive"
env DEBIAN_PRIORITY="critical"
RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.10-1_all.deb
RUN sudo -E dpkg -i mysql-apt-config_0.8.10-1_all.deb
RUN sudo apt update
RUN echo "mysql-community-server mysql-community-server/root-pass password password" | sudo debconf-set-selections
RUN echo "mysql-community-server mysql-community-server/re-root-pass password password" | sudo debconf-set-selections
RUN echo "mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)" | sudo debconf-set-selections
RUN sudo -E apt install -y mysql-server libmysqlclient-dev

# Install java
COPY ./jdk1.8.0_191 /opt/jdk1.8.0_191
ENV PATH="/opt/jdk1.8.0_191/bin:${PATH}"
RUN chmod +x /opt/jdk1.8.0_191/bin/*

RUN /bin/bash -l -c "cd /var/tmp && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.4.tar.gz"
RUN /bin/bash -l -c "cd /var/tmp && tar -xvf elasticsearch-6.2.4.tar.gz"
RUN chmod +x /var/tmp/elasticsearch-6.2.4/bin/elasticsearch-plugin
RUN /var/tmp/elasticsearch-6.2.4/bin/elasticsearch-plugin install analysis-kuromoji
RUN /var/tmp/elasticsearch-6.2.4/bin/elasticsearch-plugin install analysis-smartcn
RUN chmod -R 777 /var/tmp/elasticsearch-6.2.4

# # 8.1
RUN sudo apt install -y nodejs
# 
# # mecab 0.996-5; ipadic 2.7.0-20070801+main-1
RUN sudo apt install -y mecab mecab-ipadic-utf8 libmecab-dev
# 
# # 2.1.1
COPY ./circleci /var/tmp/circleci
RUN chmod +x /var/tmp/circleci/*.sh
RUN sudo /var/tmp/circleci/install_phantomjs.sh
RUN chmod +x /usr/local/bin/phantomjs
# 
RUN sudo apt-add-repository -y ppa:rael-gc/rvm
RUN sudo apt update
RUN sudo apt install -y rvm
RUN /bin/bash -l -c "rvm install 2.5.3"
RUN /bin/bash -l -c "gem install bundler"
RUN echo "source /etc/profile.d/rvm.sh" >> /root/.bashrc
# 
# # Needed for cld gem
ENV CFLAGS="-Wno-narrowing"
ENV CXXFLAGS="-Wno-narrowing"
# 
# RUN mkdir -p /usr/share/rvm/rubies/ruby-2.4.4/lib/ruby/gems/2.4.0/gems/bundler-1.16.3/exe
# RUN ln -s /usr/share/rvm/rubies/ruby-2.4.4/lib/ruby/gems/2.4.0/gems/bundler-1.16.2/exe/bundle /usr/share/rvm/rubies/ruby-2.4.4/lib/ruby/gems/2.4.0/gems/bundler-1.16.3/exe/bundle
# 
# ENV PATH="/opt/jdk1.8.0_191/bin:${PATH}"
# RUN echo "source /etc/profile.d/rvm.sh" >> /home/kuma/.bashrc


# Start mysql daemon
COPY ./script.sh /opt/script.sh
CMD chmod 777 /opt/script.sh
CMD chmod 777 /root/.bashrc
# CMD /usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql -D --log-error=/var/log/mysql/error.log --pid-file=/var/run/mysqld/mysqld.pid --socket=/var/run/mysqld/mysqld.sock

RUN useradd -m kuma && echo "kuma:kuma" | chpasswd && adduser kuma sudo

# COPY ./kuma /var/tmp/kuma
# RUN sudo apt install -y vim
# COPY ./tmp /var/tmp/tmp
# RUN chmod 777 /var/tmp/tmp/*

USER kuma
ENV PATH="/opt/jdk1.8.0_191/bin:${PATH}"
RUN echo "source /etc/profile.d/rvm.sh" >> /home/kuma/.bashrc
CMD /bin/bash
