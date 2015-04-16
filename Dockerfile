# Scala for Ubuntu 14.04
#
# GitHub - http://github.com/dalekurt/docker-scala
# Docker Hub - http://hub.docker.com/u/dalekurt/scala
# Twitter - http://www.twitter.com/dalekurt

FROM dalekurt/base

MAINTAINER Dale-Kurt Murray "dalekurt.murray@gmail.com"

ENV SCALA_VERSION 2.11.6
ENV SBT_VERSION 0.13.8
ENV SCALA_TARBALL http://www.scala-lang.org/files/archive/scala-${SCALA_VERSION}.deb
ENV SBT_JAR       https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar

# Typesafe repo (contains old versions but they have all dependencies we need later on)
RUN wget http://apt.typesafe.com/repo-deb-build-0002.deb
RUN dpkg -i repo-deb-build-0002.deb
RUN rm -f repo-deb-build-0002.deb

RUN wget -nv $SCALA_TARBALL
RUN dpkg -i scala-${SCALA_VERSION}.deb

RUN wget -nv -P /usr/local/bin/  $SBT_JAR

# clean up
RUN rm -f *.deb
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# make sbt executable
ADD scripts/sbt /usr/local/bin/
RUN chmod +x /usr/local/bin/sbt

# Create an empty sbt project
ADD scripts/test-sbt.sh /tmp/
RUN cd /tmp && \
    ./test-sbt.sh && \
    rm -rf *

# print versions
#RUN java -version

# scala -version returns code 1 instead of 0 thus || echo '' > /dev/null
#RUN scala -version || echo '' > /dev/null

# fetches all sbt jars from Maven repo so that your sbt will be ready to be used when you launch the image
#RUN sbt --version

# Run scala as default command
CMD ["scala"]
