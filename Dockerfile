# This dockerfile brings consistent runtime environment for development

FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
  nano vim \
  && rm -rf /var/lib/apt/lists/*

ARG USER_ID=6666
ARG DEPLOY_APP=false

WORKDIR /besharp/

ENV PATH="/besharp/bin/:${PATH}"

RUN useradd -m dev -u${USER_ID} 2> /dev/null \
    || ( usermod -l dev $( id -u -n ${USER_ID} ) && mkhomedir_helper dev )

ADD / /besharp/

RUN if $DEPLOY_APP; then \
    /besharp/bin/build --preset $( cat /besharp/build/default.preset) ; \
    echo 'deploy-app' > /besharp-docker-deploy-mode; \
else \
    echo 'deploy-framework' > /besharp-docker-deploy-mode; \
fi

USER dev

ENTRYPOINT [ "/besharp/docker/docker-entrypoint.sh" ]

CMD [ "bash" ]