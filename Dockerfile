FROM ariya/centos7-oracle-jre7

MAINTAINER Carlos Moro <dordoka@gmail.com>

# TeamCity data is stored in a volume to facilitate container upgrade
VOLUME  ["/data/teamcity"]
ENV TEAMCITY_DATA_PATH /data/teamcity

# Download and install TeamCity to /opt
RUN yum -y install tar wget
ENV TEAMCITY_PACKAGE TeamCity-8.1.5.tar.gz
ENV TEAMCITY_DOWNLOAD http://download.jetbrains.com/teamcity/
RUN wget -qO- $TEAMCITY_DOWNLOAD/$TEAMCITY_PACKAGE | tar xz -C /opt

EXPOSE 8111
CMD ["/opt/TeamCity/bin/teamcity-server.sh", "run"]
