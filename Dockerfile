# Specifing the base image
FROM        vaibhavtodi/debian-java:latest

# Maintainer
MAINTAINER  "Vaibhav Todi" <vaibhavtodi1989@gmail.com>

# Specifing the Label
LABEL       Description="Elasticsearch Docker image"                                                \
            Version="1.7"

# Setting the ENV variable
ENV         JAVA           /usr/lib/jvm/java-8-oracle

# Downloading & Installing the Elasticsearch package
RUN         apt-get        update                                                                   \
       &&   apt-get        install -y wget                                                          \
       &&   wget    -qO -  https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -        \
       &&   echo           "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" | tee -a /etc/apt/sources.list.d/elasticsearch-1.7.list \
       &&   apt-get        update                                                                   \
       &&   apt-get        install   -y   elasticsearch

# Copying the elasticsearch.yml deafult file & entrypoint.sh for running the service
COPY        elasticsearch.yml       /etc/elasticsearch/elasticsearch.yml
COPY        entrypoint.sh           /etc/elasticsearch/entrypoint.sh

# Setting up elasticsearch
RUN         sed -i 's/es_cluster/graylog/'                     /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_node_master/true/'                    /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_node_data/true/'                      /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_no_shards/5/'                         /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_no_replicas/1/'                       /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_conf_path/\/etc\/elasticsearch/'      /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_data_path/\/var\/lib\/elasticsearch/' /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_log_path/\/var\/log\/elasticsearch/'  /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_mlockall/true/'                       /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_network_host/0\.0\.0\.0/'             /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_tcp_port/9300/'                       /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_http_port/9200/'                      /etc/elasticsearch/elasticsearch.yml                    \
       &&   sed -i 's/es_unicast/["127\.0\.0\.1:9300"]/'       /etc/elasticsearch/elasticsearch.yml

RUN         for path in                                                                             \
                /var/lib/elasticsearch                                                              \
                /var/log/elasticsearch                                                              \
                /etc/elasticsearch                                                                  \
                /var/run/elasticsearch                                                              \
                /usr/share/elasticsearch                                                            \
            ; do \
                chown -R elasticsearch:elasticsearch "$path";                                       \
            done

# Clearing the Docker image
RUN         apt-get   -y    clean                                                                   \
       &&   rm        -rf   /var/lib/apt/lists/*                                                    \
       &&   rm        -rf   /var/cache/*

# Setting the passwd for root
RUN         echo      "root:root"    |   chpasswd

# Exposing the Ports
EXPOSE      9200       9300

# Mounting the log & data directory
VOLUME      ["/var/lib/elasticsearch", "/var/log/elasticsearch", "/etc/elasticsearch"]

# Changing the User
USER        elasticsearch

# Specifing the entrypoint
CMD         ["/etc/elasticsearch/entrypoint.sh"]
