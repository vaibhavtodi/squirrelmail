# Specifing the base image
FROM            debian:8.3

# Maintainer
MAINTAINER      "Vaibhav Todi"      <vaibhavtodi1989@gmail.com>

# Specifing the Label
LABEL           Description="Squirrel Mail Docker image"                                                     \
                Version="1.0"

# Setting the working directory
ENV             home                /root
WORKDIR         $home

# Setting up the ENV variables for Apache2
ENV             APACHE_RUN_USER  = www-data               \
                APACHE_RUN_GROUP = www-data               \
                APACHE_PID_FILE  = /var/run/apache2.pid   \
                APACHE_RUN_DIR   = /var/run/apache2       \
                APACHE_LOCK_DIR  = /var/lock/apache2      \
                APACHE_LOG_DIR   = /var/log/apache2       \

# Downloading & Installing the squirrelmail Package
RUN             apt-get             update                                                                   \
        &&      DEBIAN_FRONTEND=noninteractive apt-get   install  -y  wget  curl  vim  apache2               \
                                                                      libapache2-mod-php5                    \
        &&      mkdir               /var/lock/apache2                                                        \
        &&      tar                 -xvzf      squirrelmail-1.4.22.tar.gz                                    \
        &&      rm                  -f         squirrelmail-1.4.22.tar.gz

# Clearing the Docker image
RUN             apt-get             -y         clean                                                         \
        &&      rm                  -rf        /var/lib/apt/lists/*                                          \
        &&      rm                  -rf        /var/cache/*

# Copying the entrypoint.sh
COPY            entrypoint.sh       /entrypoint.sh

# Exposing the Ports
EXPOSE          80

# Mounting the log & data directory
VOLUME          ["/etc/squirrelmail, /etc/apache2, /var/log/apache2, /var/log/squirrelmail"]

# Specifing the entrypoint
CMD             ["/entrypoint.sh"]
