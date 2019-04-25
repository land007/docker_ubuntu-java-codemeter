FROM land007/ubuntu-codemeter:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

# Install Java.
ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/usr/lib/jvm/java-11-oracle

RUN VERSION=11.0.3 && \
    BUILD=9 && \
    SIG=f51449fcd52f4d52b93a989c5c56ed3c && \
    apt-get update && apt-get dist-upgrade -y && \
    apt-get install apt-utils ca-certificates curl -y --no-install-recommends && \
    curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem \
        --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        http://download.oracle.com/otn-pub/java/jdk/"${VERSION}"+"${BUILD}"/"${SIG}"/jdk-"${VERSION}"_linux-x64_bin.tar.gz \
        | tar xz -C /tmp && \
    mkdir -p /usr/lib/jvm && mv /tmp/jdk-${VERSION} "${JAVA_HOME}" && \
    apt-get autoclean && apt-get --purge -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
    update-alternatives --set java "${JAVA_HOME}/bin/java" && \
    update-alternatives --set javac "${JAVA_HOME}/bin/javac"

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-11-oracle
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:$JAVA_HOME/bin
RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle' >> /etc/profile && echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' >> /etc/profile && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile

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
