ARG base_image
# hadolint ignore=DL3006
FROM "${base_image}"

LABEL org.opencontainers.image.title='Travel Kit'
LABEL org.opencontainers.image.url='https://github.com/evolutics/travel-kit'

COPY src /opt/travel-kit
RUN ln -s /opt/travel-kit/main.sh /usr/local/bin/travel-kit

WORKDIR /workdir

ENTRYPOINT ["travel-kit"]
