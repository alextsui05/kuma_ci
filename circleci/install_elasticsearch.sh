#!/bin/bash
if [[ ! -e /var/tmp/elasticsearch-1.7.1 ]]; then
  cd /var/tmp
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.7.1.tar.gz
  tar -xvf elasticsearch-1.7.1.tar.gz
  elasticsearch-1.7.1/bin/plugin --install elasticsearch/elasticsearch-analysis-kuromoji/2.6.0
  elasticsearch-1.7.1/bin/plugin --install elasticsearch/elasticsearch-analysis-smartcn/2.7.0
fi
