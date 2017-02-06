FROM eclipse/stack-base:ubuntu

#************************************Install ENVIRONMENT SOFTWARE******************************************
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    g++ \
    gcc \
    libc6-dev \
    make \
	build-essential \
	libssl-dev \
	libkrb5-dev \
	ruby-full \
	rubygems \
	&& sudo gem install sass compass \
	&& sudo apt-get clean \
	&& sudo apt-get -y autoremove \
    && sudo apt-get -y clean \
    && sudo rm -rf /var/lib/apt/lists/*

#************************************Install and Configure GOLANG******************************************
ENV GOLANG_VERSION 1.6.2
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 e40c36ae71756198478624ed1bb4ce17597b3c19d243f3f0899bb5740d56212a

RUN sudo curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
    && sudo tar -C /usr/local -xzf golang.tar.gz \
    && sudo rm golang.tar.gz
	
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN sudo mkdir -p "$GOPATH/src" "$GOPATH/bin" && sudo chmod -R 777 "$GOPATH"

#************************************Install and Configure MAVEN******************************************
ENV MAVEN_VERSION=3.3.9 \
    JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV M2_HOME=/home/user/apache-maven-$MAVEN_VERSION
ENV PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH

RUN mkdir /home/user/apache-maven-$MAVEN_VERSION && \
    wget -qO- "http://apache.ip-connect.vn.ua/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C /home/user/apache-maven-$MAVEN_VERSION/ \
    && sudo rm -rf apache-maven-$MAVEN_VERSION-bin.tar.gz \
    && echo "export MAVEN_OPTS=\$JAVA_OPTS" >> /home/user/.bashrc
	
#************************************Install and Configure NODE******************************************
ENV NODE_VERSION=5.11.0 \
    NODE_PATH=/usr/local/lib/node_modules 
	
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done 

RUN cd /home/user && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && sudo tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && sudo rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && sudo ln -s /usr/local/bin/node /usr/local/bin/nodejs

#************************************Install and Configure NPM******************************************
RUN sudo curl -L https://npmjs.org/install.sh | sudo sh
