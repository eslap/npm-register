FROM alpine:3.4
MAINTAINER Jeff Dickey

# Install NodeJS and node-gyp deps
RUN apk --no-cache add \
        g++ \
        gcc \
        make \
        bash \
        gnupg \
        paxctl \
        python \
        nodejs \
        linux-headers

ARG user=register
ARG group=register
ARG uid=1000
ARG gid=1000

# If you bind mount a volume from the host or a data container, 
# ensure you use the same uid
# Create user and group
RUN addgroup -S ${gid} ${group} \
    && adduser -D -S \
        -s /bin/bash \
        -h /srv/npm-register \
        -G ${group} \
        -u ${uid} \
        ${user}

# Deploy application
COPY . /srv/npm-register
WORKDIR /srv/npm-register
RUN npm install \
    && chown -R ${user}:${group} .

# Share storage volume
ENV NPM_REGISTER_FS_DIRECTORY /data
VOLUME /data

# Start application
EXPOSE 3000
USER ${user}
ENV NODE_ENV production
CMD ["npm", "start"]

