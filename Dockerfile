FROM rust:1 as build

ARG BORINGTUN_VERSION=1f842a6

RUN export target=`uname -m`-unknown-linux-musl \
 && rustup target install $target \
 && apt update && apt install -y musl-tools \
 && cargo install boringtun --git='https://github.com/cloudflare/boringtun.git' --rev=${BORINGTUN_VERSION} --target=$target \
 && rm -rf /usr/local/cargo/registry 

FROM scratch
COPY --from=build /usr/local/cargo/bin/boringtun .
VOLUME ["/var/run/wireguard/"]
ENTRYPOINT ["./boringtun", "--log=/dev/stdout", "--err=/dev/stderr", "--foreground"]
