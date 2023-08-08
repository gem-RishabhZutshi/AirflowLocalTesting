# # BUILD: docker build --rm -t airflow .
# # ORIGINAL SOURCE: https://github.com/puckel/docker-airflow

# FROM python:3.8.5-slim
# LABEL version="1.1"
# LABEL maintainer="nicor88"

# # Never prompts the user for choices on installation/configuration of packages
# ENV DEBIAN_FRONTEND noninteractive
# ENV TERM linux

# # Airflow
# ARG AIRFLOW_VERSION=2.1.0
# ENV AIRFLOW_HOME=/usr/local/airflow
# ENV AIRFLOW_GPL_UNIDECODE=yes
# # celery config
# ARG CELERY_REDIS_VERSION=4.4.7
# ARG PYTHON_REDIS_VERSION=3.5.3

# ARG TORNADO_VERSION=6.1.0
# ARG WERKZEUG_VERSION=2.0.1

# # Define en_US.
# ENV LANGUAGE en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LC_ALL en_US.UTF-8
# ENV LC_CTYPE en_US.UTF-8
# ENV LC_MESSAGES en_US.UTF-8
# ENV LC_ALL en_US.UTF-8

# RUN set -ex \
#     && buildDeps=' \
#         python3-dev \
#         libkrb5-dev \
#         libsasl2-dev \
#         libssl-dev \
#         libffi-dev \
#         build-essential \
#         libblas-dev \
#         liblapack-dev \
#         libpq-dev \
#         git \
#     ' \
#     && apt-get update -yqq \
#     && apt-get upgrade -yqq \
#     && apt-get install pkg-config \
#     && apt-get install -yqq --no-install-recommends \
#         ${buildDeps} \
#         sudo \
#         python3-pip \
#         python3-requests \
#         default-mysql-client \
#         default-libmysqlclient-dev \
#         apt-utils \
#         curl \
#         rsync \
#         netcat \
#         locales \
#     && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
#     && locale-gen \
#     && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
#     && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
#     && pip install -U pip setuptools wheel \
#     && pip install --no-cache-dir pytz \
#     && pip install --no-cache-dir pyOpenSSL \
#     && pip install --no-cache-dir ndg-httpsclient \
#     && pip install --no-cache-dir pyasn1 \
#     && pip install --no-cache-dir typing_extensions \
#     && pip install --no-cache-dir mysqlclient \
#     && pip install --no-cache-dir apache-airflow[async,aws,crypto,celery,github_enterprise,kubernetes,jdbc,postgres,password,s3,slack,ssh]==${AIRFLOW_VERSION} \
#     && pip install --no-cache-dir werkzeug==${WERKZEUG_VERSION} \
#     && pip install --no-cache-dir redis==${PYTHON_REDIS_VERSION} \
#     && pip install --no-cache-dir celery[redis]==${CELERY_REDIS_VERSION} \
#     && pip install --no-cache-dir flask_oauthlib \
#     && pip install --no-cache-dir SQLAlchemy==1.3.23 \
#     && pip install --no-cache-dir Flask-SQLAlchemy==2.4.4 \
#     && pip install --no-cache-dir psycopg2-binary \
#     && pip install --no-cache-dir tornado==${TORNADO_VERSION} \
#     && apt-get purge --auto-remove -yqq ${buildDeps} \
#     && apt-get autoremove -yqq --purge \
#     && apt-get clean \
#     && rm -rf \
#         /var/lib/apt/lists/* \
#         /tmp/* \
#         /var/tmp/* \
#         /usr/share/man \
#         /usr/share/doc \
#         /usr/share/doc-base











# VERSION 1.10.9
# AUTHOR: Matthieu "Puckel_" Roisil
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t puckel/docker-airflow .
# SOURCE: https://github.com/puckel/docker-airflow

FROM python:3.7-slim-buster
LABEL maintainer="Puckel_"

# Never prompt the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=1.10.9
ARG AIRFLOW_USER_HOME=/usr/local/airflow
ARG AIRFLOW_DEPS=""
ARG PYTHON_DEPS=""
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

# Disable noisy "Handling signal" log messages:
# ENV GUNICORN_CMD_ARGS --log-level WARNING

RUN set -ex \
    && buildDeps=' \
        freetds-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        libpq-dev \
        git \
    ' \
    && apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        freetds-bin \
        build-essential \
        default-libmysqlclient-dev \
        apt-utils \
        curl \
        rsync \
        netcat \
        locales \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_USER_HOME} airflow \
    && pip install -U pip setuptools wheel \
    && pip install pytz \
    && pip install pyOpenSSL \
    && pip install ndg-httpsclient \
    && pip install pyasn1 \
    && pip install apache-airflow[crypto,celery,postgres,hive,jdbc,mysql,ssh${AIRFLOW_DEPS:+,}${AIRFLOW_DEPS}]==${AIRFLOW_VERSION} \
    && pip install 'redis==3.2' \
    && if [ -n "${PYTHON_DEPS}" ]; then pip install ${PYTHON_DEPS}; fi \
    && apt-get purge --auto-remove -yqq $buildDeps \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base


COPY config/entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
COPY dags ${AIRFLOW_HOME}/dags
COPY plugins ${AIRFLOW_HOME}/plugins

RUN chown -R airflow: ${AIRFLOW_HOME}

ENV PYTHONPATH ${AIRFLOW_HOME}

USER airflow

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

EXPOSE 8080 5555 8793

WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["scheduler"]


