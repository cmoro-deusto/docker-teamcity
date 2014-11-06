FROM ubuntu:14.04.1

MAINTAINER Carlos Moro <dordoka@gmail.com>

# Fix add-apt-repo in ubuntu docker
RUN apt-get update && \
    apt-get install -y software-properties-common

# Install Java and dependencies
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer wget unzip tar && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
RUN groupadd teamcity
RUN useradd teamcity -m -g teamcity -s /bin/bash
RUN passwd -d -u teamcity
RUN echo "teamcity ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/teamcity
RUN chmod 0440 /etc/sudoers.d/teamcity

# TeamCity data is stored in a volume to facilitate container upgrade
VOLUME  ["/data/teamcity"]
ENV TEAMCITY_DATA_PATH /data/teamcity
RUN chown teamcity:teamcity /data/teamcity

# Download and install TeamCity to /opt
WORKDIR /tmp
ENV TEAMCITY_PACKAGE TeamCity-8.1.5.tar.gz
ENV TEAMCITY_DOWNLOAD http://download.jetbrains.com/teamcity/
RUN wget -qO- $TEAMCITY_DOWNLOAD/$TEAMCITY_PACKAGE | tar xz -C /opt

EXPOSE 8111
CMD ["/opt/TeamCity/bin/teamcity-server.sh", "run"]
