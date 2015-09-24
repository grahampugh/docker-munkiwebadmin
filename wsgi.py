import os, sys
import site

MWA_ENV_DIR = '/home/docker/munkiwebadmin'

# Use site to load the site-packages directory of our virtualenv
site.addsitedir(os.path.join(MWA_ENV_DIR, 'lib/python2.7/site-packages'))

# Make sure we have the virtualenv and the Django app itself added to our path
sys.path.append(MWA_ENV_DIR)
sys.path.append(os.path.join(MWA_ENV_DIR, 'munkiwebadmin'))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "munkiwebadmin.settings")
import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()