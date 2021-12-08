FROM ubuntu:18.04 as builder

ARG version=0.4.5
ENV nanopb=nanopb-${version}-linux-x86
ENV file=${nanopb}.tar.gz

WORKDIR /usr/src/app
RUN apt-get update && apt-get install -y python3 curl nano bash
RUN curl -O https://jpa.kapsi.fi/nanopb/download/${file} && tar -xzf ${file}
RUN mkdir generator && cp -a ${nanopb}/. generator

ENV DART_VERSION=2.13.14
ENV DART_PROTOBUF_VERSION=2.0.0

FROM dart:stable AS dart_builder
RUN apt-get update && apt-get install -y musl-tools curl

RUN mkdir -p /dart-protobuf
RUN curl -sSL https://api.github.com/repos/google/protobuf.dart/tarball/protobuf-v${DART_PROTOBUF_VERSION} | tar xz --strip 1 -C /dart-protobuf

WORKDIR /dart-protobuf/protoc_plugin

RUN pub install 
RUN dart2native --verbose bin/protoc_plugin.dart -o protoc_plugin
RUN install -D /dart-protobuf/protoc_plugin/protoc_plugin /out/usr/bin/protoc-gen-dart

ENV DART_PROTOC_DIR=/out/usr/bin
ENV PATH=${DART_PROTOC_DIR}:${PATH}

WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/generator .

COPY build-protoc.sh .
CMD [ "./build-protoc.sh" ]
