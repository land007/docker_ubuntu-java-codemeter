FROM land007/ubuntu-codemeter:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

# Install Java.
#RUN apt-get install -y software-properties-common
#RUN \
#  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
#  add-apt-repository -y ppa:webupd8team/java && \
#  apt-get update && \
#  apt-get install -y oracle-java8-installer && \
#  rm -rf /var/lib/apt/lists/* && \
#  rm -rf /var/cache/oracle-jdk8-installer
RUN add-apt-repository -y ppa:linuxuprising/java && \
  echo debconf shared/accepted-oracle-license-v1-2 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-2 seen true | debconf-set-selections && \
  apt-get update && apt-get install -y oracle-java11-installer
# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-11-oracle
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:$JAVA_HOME/bin
RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-11-oracle' >> /etc/profile && echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' >> /etc/profile && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile

# Define working directory.
#RUN mkdir /java
ADD java /java
RUN cd /java && javac Main.java
RUN ln -s /java ~/
RUN ln -s /java /home/land007
RUN mv /java /java_
WORKDIR /java
VOLUME ["/java"]
ADD check.sh /
RUN sed -i 's/\r$//' /check.sh
RUN chmod a+x /check.sh

CMD /check.sh /java ; /etc/init.d/ssh start ; bash
EXPOSE 8080

#docker stop ubuntu-java-codemeter ; docker rm ubuntu-java-codemeter ; docker run -it --privileged --name ubuntu-java-codemeter land007/ubuntu-java-codemeter:latest
