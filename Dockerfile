FROM buildpack-deps:stable

ENV LANG C.UTF-8

ENV TRUFFLERUBY_VERSION=24.2.0

RUN set -eux ;\
    wget -q https://github.com/oracle/truffleruby/releases/download/graal-$TRUFFLERUBY_VERSION/truffleruby-jvm-$TRUFFLERUBY_VERSION-linux-amd64.tar.gz

RUN tar -xzf truffleruby-jvm-$TRUFFLERUBY_VERSION-linux-amd64.tar.gz -C /usr/local --strip-components=1 ;\
    rm truffleruby-jvm-$TRUFFLERUBY_VERSION-linux-amd64.tar.gz ;\
    /usr/local/lib/truffle/post_install_hook.sh ;\
    ruby --version ;\
    gem --version ;\
    bundle --version

# don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $GEM_HOME/bin:$PATH

# adjust permissions of a few directories for running "gem install" as an arbitrary user
RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"

CMD [ "irb" ]
