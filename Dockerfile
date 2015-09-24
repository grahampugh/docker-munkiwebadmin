# MunkiWebAdmin Dockerfile Version 0.2
FROM phusion/passenger-full:0.9.17
MAINTAINER Graham Pugh <g.r.pugh@gmail.com>

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV APP_DIR /home/docker/munkiwebadmin
ENV TIME_ZONE America/New_York
ENV APPNAME MunkiWebAdmin
ENV MUNKI_REPO_DIR /munki_repo
ENV MANIFEST_USERNAME_KEY user
ENV MANIFEST_USERNAME_IS_EDITABLE False
ENV WARRANTY_LOOKUP_ENABLED False
ENV MODEL_LOOKUP_ENABLED False

ENV DOCKER_MWA_TZ America/New_York
ENV DOCKER_MWA_ADMINS Docker User, docker@localhost
ENV DOCKER_MWA_LANG en_US
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
    libffi-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# required in Ubuntu 14.04
ADD policy-rc.d /usr/sbin/policy-rc.d

RUN easy_install pip && \
    git clone https://github.com/stevekueng/munkiwebadmin.git $APP_DIR && \
    git clone https://github.com/munki/munki.git /munki-tools && \
    pip install psycopg2==2.5.3 && \
#     pip install gunicorn && \
    pip install setproctitle

ADD requirements.txt $APP_DIR/requirements.txt
RUN pip install -r $APP_DIR/requirements.txt
ADD nginx/nginx-env.conf /etc/nginx/main.d/
ADD nginx/munkiwebadmin.conf /etc/nginx/sites-enabled/munkiwebadmin.conf
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD settings.py $APP_DIR/munkiwebadmin/
ADD settings_import.py $APP_DIR/munkiwebadmin/
ADD munkiwebadmin.wsgi $APP_DIR/munkiwebadmin.wsgi
ADD urls.py $APP_DIR/urls.py
# ADD gunicorn_config.py $APP_DIR/
ADD django/management/ $APP_DIR/munkiwebadmin/management/
ADD run.sh /run.sh
ADD supervisord.conf $APP_DIR/supervisord.conf

# RUN groupadd munki
# RUN usermod -g munki app

RUN update-rc.d -f postgresql remove && \
    update-rc.d -f nginx remove && \
    rm -f /etc/nginx/sites-enabled/default && \
    mkdir -p /home/app && \
    mkdir -p /home/backup && \
    ln -s $APP_DIR /home/app/munkiwebadmin

VOLUME ["/munki_repo" ]
EXPOSE 80

CMD ["/run.sh"]
