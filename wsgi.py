import os, sys
import site

MWA_ENV_DIR='/home/docker/munkiwebadmin'

# Use site to load the site-packages directory of our virtualenv
site.addsitedir(os.path.join(MWA_ENV_DIR, 'lib/python2.7/site-packages'))

# Make sure we have the virtualenv and the Django app itself added to our path
sys.path.append(MWA_ENV_DIR)
sys.path.append(os.path.join(MWA_ENV_DIR, 'munkiwebadmin'))
from django.core.handlers.wsgi import WSGIHandler
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
application = WSGIHandler()