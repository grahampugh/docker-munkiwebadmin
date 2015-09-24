# MunkiWebAdmin Dockerfile Version 0.2
FROM ubuntu:14.04.1
MAINTAINER Graham Pugh <g.r.pugh@gmail.com>

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV APP_DIR /home/app/munkiwebadmin
ENV TIME_ZONE America/New_York
ENV APPNAME MunkiWebAdmin
ENV MUNKI_REPO_DIR /munki_repo
ENV MANIFEST_USERNAME_KEY user
ENV MANIFEST_USERNAME_IS_EDITABLE False
ENV WARRANTY_LOOKUP_ENABLED False
ENV MODEL_LOOKUP_ENABLED False

ENV DOCKER_MWA_TZ America/New_York
ENV DOCKER_MWA_ADMINS Docker User, docker@localhost
ENV DOCKER_MWA_LANG en_GB
ENV DOCKER_MWA_DISPLAY_NAME MunkiWebAdmin

# Install python
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get -y update && \
    add-apt-repository -y ppa:nginx/stable && \
    apt-get -y install \
    git \
    python-setuptools \
    nginx \
    postgresql \
    postgresql-contrib \
    libpq-dev \
    python-dev \
    libpq-dev \
    supervisor \
    nano \
    libffi-dev

ADD django/ $APP_DIR/
ADD django/requirements.txt $APP_DIR/

RUN easy_install pip && \
    git clone https://github.com/stevekueng/munkiwebadmin.git $APP_DIR && \
    git clone https://github.com/munki/munki.git /munki-tools && \
    pip install -r $APP_DIR/setup/requirements.txt && \
    pip install psycopg2==2.5.3 && \
    pip install gunicorn && \
    pip install setproctitle

ADD nginx/nginx-env.conf /etc/nginx/main.d/
ADD nginx/munkiwebadmin.conf /etc/nginx/sites-enabled/munkiwebadmin.conf
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD settings.py $APP_DIR/sal/
ADD settings_import.py $APP_DIR/sal/
ADD wsgi.py $APP_DIR/
ADD gunicorn_config.py $APP_DIR/
ADD django/management/ $APP_DIR/munkiwebadmin/management/
ADD run.sh /run.sh
ADD supervisord.conf $APP_DIR/supervisord.conf

RUN groupadd munki
RUN usermod -g munki app

RUN update-rc.d -f postgresql remove && \
    update-rc.d -f nginx remove && \
    rm -f /etc/nginx/sites-enabled/default && \
    mkdir -p /home/backup

VOLUME ["/munki_repo", "/home/app/munkiwebadmin" ]
EXPOSE 8080

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/run.sh"]
