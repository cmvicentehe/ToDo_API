FROM swift:5.6 as builder

RUN apt-get -qq update && apt-get install -y \
  libssl-dev zlib1g-dev \
  libsqlite3-dev \
  && rm -r /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so* /build/lib
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin

# Production image
FROM ubuntu:18.04
# DEBIAN_FRONTEND=noninteractive for automatic UTC configuration in tzdata
RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get install -y \ 
  libatomic1 libicu60 libxml2 libcurl4 libz-dev libbsd0 tzdata \
  && rm -r /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /build/bin/Run .
COPY --from=builder /build/lib/* /usr/lib/
COPY --from=builder /app/Public ./Public
COPY --from=builder /app/Resources ./Resources

ENTRYPOINT ./Run serve --env docker --hostname 0.0.0.0
