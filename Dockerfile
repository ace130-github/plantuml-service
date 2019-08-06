# https://hub.docker.com/_/openjdk/
FROM openjdk:13-alpine

ARG PLANTUML_SERVICE_VERSION="1.3.5"
ARG PLANTUML_SERVICE_JAR_URL="https://github.com/bitjourney/plantuml-service/releases/download/v${PLANTUML_SERVICE_VERSION}/plantuml-service.jar"
ARG PLANTUML_SERVICE_BIN_DIR="/home/app/plantuml-service/bin"
ARG PLANTUML_SERVICE_PATH="${PLANTUML_SERVICE_BIN_DIR}/plantuml-service.jar"

RUN echo "${PLANTUML_SERVICE_VERSION?:--build-arg PLANTUML_SERVICE_VERSION=version is mandatory}"

USER root

RUN adduser -S app \
  && apk update \
  && apk upgrade \
  && apk add graphviz curl fontconfig ttf-dejavu \
  && mkdir -p ${PLANTUML_SERVICE_BIN_DIR} \
  && curl -L ${PLANTUML_SERVICE_JAR_URL} -o ${PLANTUML_SERVICE_PATH} \
  && chown -R app ${PLANTUML_SERVICE_BIN_DIR}

USER app

EXPOSE 1608

ENTRYPOINT ["java"]
CMD ["-jar", "/home/app/plantuml-service/bin/plantuml-service.jar"]
