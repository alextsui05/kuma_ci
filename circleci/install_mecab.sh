#!/bin/bash

if [ ! -e /usr/local/bin/mecab ]; then
# Remove mecab
sudo apt-get remove mecab

# Install mecab
cd /var/tmp
if [[ ! -e mecab-0.996 ]]; then
  wget -O mecab-0.996.tar.gz 'https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE'
  tar zxfv mecab-0.996.tar.gz
  cd mecab-0.996
  ./configure
  make
else
  cd mecab-0.996
fi
sudo make install

# load mecab.so
sudo sh -c "echo '/usr/local/lib' >> /etc/ld.so.conf"
sudo ldconfig

# Install mecab-ipadic
cd /var/tmp
if [[ ! -e mecab-ipadic-2.7.0-20070801 ]]; then
  wget -O mecab-ipadic-2.7.0-20070801.tar.gz 'https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM'
  tar zxfv mecab-ipadic-2.7.0-20070801.tar.gz
  cd mecab-ipadic-2.7.0-20070801
  ./configure --with-charset=utf8
  make
else
  cd mecab-ipadic-2.7.0-20070801
fi
sudo make install
fi
