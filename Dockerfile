# FROM python:3.7-slim-buster
# LABEL maintainer="Puckel_"

# # Never prompt the user for choices on installation/configuration of packages
# ENV DEBIAN_FRONTEND noninteractive
# ENV TERM linux

# # Airflow
# ARG AIRFLOW_VERSION=1.10.9
# ARG AIRFLOW_USER_HOME=/usr/local/airflow
# ARG AIRFLOW_DEPS=""
# ARG PYTHON_DEPS=""
# ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

# # Define en_US.
# ENV LANGUAGE en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LC_ALL en_US.UTF-8
# ENV LC_CTYPE en_US.UTF-8
# ENV LC_MESSAGES en_US.UTF-8


# RUN set -ex \
#     && buildDeps=' \
#         freetds-dev \
#         libkrb5-dev \
#         libsasl2-dev \
#         libssl-dev \
#         libffi-dev \
#         libpq-dev \
#         redis-tools \
#         git \
#     ' \
#     && apt-get update -yqq \
#     && apt-get upgrade -yqq \
#     && apt-get install -yqq --no-install-recommends \
#         $buildDeps \
#         freetds-bin \
#         build-essential \
#         default-libmysqlclient-dev \
#         apt-utils \
#         curl \
#         rsync \
#         netcat \
#         redis-tools \
#         locales \
#     && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
#     && locale-gen \
#     && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
#     && useradd -ms /bin/bash -d ${AIRFLOW_USER_HOME} airflow \
#     && pip install -U pip setuptools wheel \
#     && pip install pytz \
#     && pip install pyOpenSSL \
#     && pip install ndg-httpsclient \
#     && pip install pyasn1 \
#     && pip install apache-airflow[crypto,celery,postgres,hive,jdbc,mysql,ssh${AIRFLOW_DEPS:+,}${AIRFLOW_DEPS}]==${AIRFLOW_VERSION} \
#     && pip install markupsafe==2.0.1 \
#     && pip install 'redis==3.2' \
#     && pip install --upgrade WTForms \
#     && if [ -n "${PYTHON_DEPS}" ]; then pip install ${PYTHON_DEPS}; fi 
    

# RUN pip install --upgrade pip && \
# pip install --upgrade awscli 


# COPY config/entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh
# COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
# COPY dags ${AIRFLOW_HOME}/dags
# COPY config/webserver_config.py ${AIRFLOW_HOME}/webserver_config.py

# RUN chown -R airflow: ${AIRFLOW_HOME}

# ENV PYTHONPATH ${AIRFLOW_HOME}

# USER airflow

# COPY requirements.txt .
# RUN pip install --user --no-cache-dir -r requirements.txt
# RUN mkdir ${AIRFLOW_HOME}/tmp


# EXPOSE 8080 5555 8793

# WORKDIR ${AIRFLOW_HOME}
# ENTRYPOINT ["/entrypoint.sh"]












# BUILD: docker build --rm -t airflow .
# ORIGINAL SOURCE: https://github.com/puckel/docker-airflow

FROM python:3.11-slim
LABEL version="1.2"
LABEL maintainer="discern"

# Airflow
ARG AIRFLOW_VERSION=2.5.3
ENV AIRFLOW_HOME=/usr/local/airflow


# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN set -ex \
    && buildDeps=' \
        python3-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        build-essential \
        libblas-dev \
        liblapack-dev \
        libpq-dev \
        git \
        gcc \
    ' \
    && apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
        ${buildDeps} \
        sudo \
        python3-pip \
        python3-requests \
        default-mysql-client \
        default-libmysqlclient-dev \
        apt-utils \
        curl \
        rsync \
        netcat-traditional \
        locales \
        postgresql-client \
        gcc \
        git \
        cmake \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && pip install -U pip setuptools==68.1.0 wheel \
    && pip install --no-cache-dir apache-airflow[async,aws,crypto,celery,github_enterprise,kubernetes,jdbc,postgres,password,s3,slack,ssh]==${AIRFLOW_VERSION} \
    && pip install --no-cache-dir cvxpy==1.3.2 \
    && apt-get purge --auto-remove -yqq ${buildDeps} \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

RUN pip install --upgrade pip && \
pip install --upgrade awscli

COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
COPY config/webserver_config.py ${AIRFLOW_HOME}/webserver_config.py
COPY dags ${AIRFLOW_HOME}/dags


RUN chown -R airflow: ${AIRFLOW_HOME}

ENV PYTHONPATH ${AIRFLOW_HOME}:${AIRFLOW_HOME}/dags:${AIRFLOW_HOME}/dags/common

USER airflow

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt
RUN mkdir ${AIRFLOW_HOME}/tmp


EXPOSE 8080 5555 8793

WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["/entrypoint.sh"]
