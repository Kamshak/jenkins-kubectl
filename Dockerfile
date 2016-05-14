FROM jenkins:2.3

USER root

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v1.2.4/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl;

 ENV NPM_CONFIG_LOGLEVEL info
 ENV NODE_VERSION 5.6.0
 ENV LC_ALL=POSIX
 
 # Node.JS and Meteor
RUN  apt-get update && \
     apt-key update && \
     apt-get -y install locales build-essential libssl-dev libkrb5-dev gcc make ruby-full rubygems-integration && \
     gem install sass compass && \
     apt-get clean && \
     apt-get -y autoremove && \
     apt-get -y clean && \
     rm -rf /var/lib/apt/lists/* && \
	set -ex \
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
  	done && \
    cd /tmp && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --verify SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt.asc | sha256sum -c - \
    &&  tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc && \
    curl https://install.meteor.com/ | sh && \
     locale-gen en_US.UTF-8 && \
	 localedef -i en_GB -f UTF-8 en_US.UTF;

USER jenkins
