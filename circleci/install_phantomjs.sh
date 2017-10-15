#!/bin/bash
if [[ ! -e /var/tmp/phantomjs-2.1.1 ]]; then
  mkdir /var/tmp/phantomjs-2.1.1
  curl --output /var/tmp/phantomjs-2.1.1/phantomjs https://s3.amazonaws.com/circle-downloads/phantomjs-2.1.1
fi
sudo cp /var/tmp/phantomjs-2.1.1/phantomjs /usr/local/bin/phantomjs
