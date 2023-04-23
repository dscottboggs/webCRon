FROM crystallang/crystal
WORKDIR /project
COPY shard.yml shard.lock /project/
RUN shards install
COPY src /project/src
RUN shards build
CMD [ "/project/bin/webcron" ]