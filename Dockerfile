ARG base_image
# hadolint ignore=DL3006
FROM "${base_image}"

LABEL org.opencontainers.image.title='Travel Kit'
LABEL org.opencontainers.image.url='https://github.com/evolutics/travel-kit'

RUN apk add --no-cache python3~=3.8

COPY src /opt/travel-kit
RUN ln -s /opt/travel-kit/main.py /usr/local/bin/travel-kit

WORKDIR /workdir

ENTRYPOINT ["travel-kit"]
