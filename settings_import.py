#!/usr/bin/python
from os import getenv
import locale

# Read list of admins from $DOCKER_MWA_ADMINS env var
admin_list = []
if getenv('DOCKER_MWA_ADMINS'):
    admins_var = getenv('DOCKER_MWA_ADMINS')
    if ',' in admins_var and ':' in admins_var:
        for admin in admins_var.split(':'):
            admin_list.append(tuple(admin.split(',')))
        ADMINS = tuple(admin_list)
    elif ',' in admins_var:
        admin_list.append(tuple(admins_var.split(',')))
        ADMINS = tuple(admin_list)
else:
    ADMINS = (
                ('Admin User', 'admin@test.com')
             )

# Read the preferred time zone from $DOCKER_MWA_TZ, use system locale or
# set to 'America/New_York' if neither are set
if getenv('DOCKER_MWA_TZ'):
    if '/' in getenv('DOCKER_MWA_TZ'):
        TIME_ZONE = getenv('DOCKER_MWA_TZ')
    else: TIME_ZONE = 'America/New_York'
# elif getenv('TZ'):
#     TIME_ZONE = getenv('TZ')
# else:
#     TIME_ZONE = 'America/New_York'

# Read the preferred language code from $DOCKER_MWA_LANG, use system locale or
# set to 'en_US' if neither are set
if getenv('DOCKER_MWA_LANG'):
    if '_' in getenv('DOCKER_MWA_LANG'):
        LANGUAGE_CODE = getenv('DOCKER_MWA_LANG')
    else:
        LANGUAGE_CODE = 'en_US'
# elif locale.getdefaultlocale():
#     LANGUAGE_CODE = locale.getdefaultlocale()[0]
else:
    LANGUAGE_CODE = 'en_US'

# Read the list of allowed hosts from the $DOCKER_MWA_ALLOWED env var, or
# allow all hosts if none was set.
if getenv('DOCKER_MWA_ALLOWED'):
    ALLOWED_HOSTS = getenv('DOCKER_MWA_ALLOWED').split(',')
else:
    ALLOWED_HOSTS = ['*']

# Set the display name from the $DOCKER_MWA_DISPLAY_NAME env var, or
# use the default
if getenv('DOCKER_MWA_DISPLAY_NAME'):
    DISPLAY_NAME = getenv('DOCKER_MWA_DISPLAY_NAME')
else:
    DISPLAY_NAME = 'MunkiWebAdmin'

# The order plugins (if they're able to be shown on that particular page) will be displayed in. If not listed here, will be listed alphabetically after.
# if getenv('DOCKER_MWA_PLUGIN_ORDER'):
#     PLUGIN_ORDER = getenv('DOCKER_MWA_PLUGIN_ORDER').split(',')
# else:
#     PLUGIN_ORDER = ['Activity','Status', 'MunkiVersion','OperatingSystem','Uptime', 'Memory']