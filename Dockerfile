FROM ubuntu:14.04

# Last Package Update & Install
RUN apt-get update && apt-get install -y curl supervisor openssh-server net-tools iputils-ping nano

# JDK 1.7 
ENV JDK_URL http://download.oracle.com/otn-pub/java/jdk 
ENV JDK_VER 7u79-b15
ENV JDK_VER2 jdk-7u79
ENV JAVA_HOME /usr/local/jdk
ENV PATH $PATH:$JAVA_HOME/bin 
RUN cd $SRC_DIR && curl -LO "$JDK_URL/$JDK_VER/$JDK_VER2-linux-x64.tar.gz" -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
  && tar xzf $JDK_VER2-linux-x64.tar.gz && mv jdk1* $JAVA_HOME && rm -f $JDK_VER2-linux-x64.tar.gz \
  && echo '' >> /etc/profile \
  && echo '# JDK' >> /etc/profile \
  && echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile \
  && echo 'export PATH="$PATH:$JAVA_HOME/bin"' >> /etc/profile \
  && echo '' >> /etc/profile

# Apache Hadoop 
ENV SRC_DIR /opt 
ENV HADOOP_URL http://www.eu.apache.org/dist/hadoop/common 
ENV HADOOP_VERSION hadoop-2.7.1 
RUN cd $SRC_DIR && curl -LO "$HADOOP_URL/$HADOOP_VERSION/$HADOOP_VERSION.tar.gz" \ 
  && tar xzf $HADOOP_VERSION.tar.gz ; rm -f $HADOOP_VERSION.tar.gz 
  
# Hadoop ENV
ENV HADOOP_PREFIX $SRC_DIR/$HADOOP_VERSION 
ENV PATH $PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin 
ENV HADOOP_MAPRED_HOME $HADOOP_PREFIX 
ENV HADOOP_COMMON_HOME $HADOOP_PREFIX 
ENV HADOOP_HDFS_HOME $HADOOP_PREFIX 
ENV YARN_HOME $HADOOP_PREFIX 
RUN echo '# Hadoop' >> /etc/profile \
  && echo "export HADOOP_PREFIX=$HADOOP_PREFIX" >> /etc/profile \
  && echo 'export PATH=$PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin' >> /etc/profile \
  && echo 'export HADOOP_MAPRED_HOME=$HADOOP_PREFIX' >> /etc/profile \
  && echo 'export HADOOP_COMMON_HOME=$HADOOP_PREFIX' >> /etc/profile \
  && echo 'export HADOOP_HDFS_HOME=$HADOOP_PREFIX' >> /etc/profile \
  && echo 'export YARN_HOME=$HADOOP_PREFIX' >> /etc/profile

# Add in the etc/hadoop directory
ADD conf/core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
ADD conf/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
ADD conf/yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
ADD conf/mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/local/jdk:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh


# SSH keygen
RUN cd /root && ssh-keygen -t dsa -P '' -f "/root/.ssh/id_dsa" \
 && cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys && chmod 644 /root/.ssh/authorized_keys

# Name node foramt
RUN hdfs namenode -format

# Supervisor
RUN mkdir -p /var/log/supervisor
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# SSH
RUN mkdir /var/run/sshd
RUN sed -i 's/without-password/yes/g' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN echo 'SSHD: ALL' >> /etc/hosts.allow

# Root password
RUN echo 'root:hadoop' |chpasswd

# Port
# Node Manager: 8042, Resource Manager: 8088, NameNode: 50070, DataNode: 50075, SecondaryNode: 50090
EXPOSE 22 8042 8088 50070 50075 50090

# Daemon
CMD ["/usr/bin/supervisord"]

# Apache Mahout
ENV MAHOUT_URL http://www.eu.apache.org/dist/mahout/
ENV MAHOUT_VERSION 0.11.0
RUN cd $SRC_DIR && curl -LO "$MAHOUT_URL/$MAHOUT_VERSION/apache-mahout-distribution-$MAHOUT_VERSION-src.tar.gz" \
  && tar xzf apache-mahout-distribution-$MAHOUT_VERSION-src.tar.gz ; rm -f apache-mahout-distribution-$MAHOUT_VERSION-src.tar.gz
 
# MAVEN
ENV MAVEN_URL http://www.eu.apache.org/dist/maven/
ENV MAVEN_VERSION maven-3
ENV MAVEN_VERSION2 3.3.3
RUN cd $SRC_DIR && curl -LO "$MAVEN_URL/$MAVEN_VERSION/$MAVEN_VERSION2/binaries/apache-maven-$MAVEN_VERSION2-bin.tar.gz" \
  && tar xzf apache-maven-$MAVEN_VERSION2-bin.tar.gz ; rm -f apache-maven-$MAVEN_VERSION2-bin.tar.gz

ENV MAHOUT_HOME $SRC_DIR/apache-mahout-distribution-$MAHOUT_VERSION
ENV MAHOUT_BIN $MAHOUT_HOME/bin
ENV MAVEN_HOME $SRC_DIR/apache-maven-$MAVEN_VERSION2
ENV MAVEN_BIN $MAVEN_HOME/bin
ENV PATH $PATH:$MAVEN_HOME:$MAVEN_BIN:$MAHOUT_HOME:$MAHOUT_BIN


RUN echo '# MAHOUT and MAVEN' >> /etc/profile \
  && echo "export MAHOUT_HOME=$MAHOUT_HOME" >> /etc/profile \
  && echo "export MAVEN_HOME=$MAVEN_HOME" >> /etc/profile \
  && echo 'export PATH=$PATH:$MAHOUT_HOME/bin:$MAVEN_HOME/bin' >> /etc/profile

RUN cd $MAHOUT_HOME && mvn install -DskipTests
RUN cd $MAHOUT_HOME/examples && mkdir temp

