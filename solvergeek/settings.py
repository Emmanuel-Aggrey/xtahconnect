"""
Django settings for solvergeek project.

Generated by 'django-admin startproject' using Django 2.1.7.

For more information on this file, see
https://docs.djangoproject.com/en/2.1/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/2.1/ref/settings/
"""

import os
from decouple import config
import dj_database_url

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/2.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!


SECRET_KEY = config('SECRET_KEY')
# SECURITY WARNING: don't run with debug turned on in production!

DEBUG = config('DEBUG', cast=bool)


ALLOWED_HOSTS = ['*']

AUTHENTICATION_BACKENDS = (
    'ecommerce.backends.CommonAuthBackend',
    'django.contrib.auth.backends.ModelBackend',
)

# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.sites',
    'django.contrib.staticfiles',
    'django.contrib.humanize',
    # 'ecommerce',

    # 3rd party
    'crispy_forms',
    'easy_thumbnails',
    # 'cloudinary_storage',
    # 'cloudinary',
    'ckeditor',
    'storages',
    'sendgrid',
    'mapbox_location_field',
    'location_field.apps.DefaultConfig',
    'tracking',

    # 'smart_selects',
    # paymant


    # logins
    'allauth',
    'allauth.account',
    'allauth.socialaccount',

    'allauth.socialaccount.providers.google',
    'allauth.socialaccount.providers.facebook',

    'django_crontab',

    'ecommerce',
    'cart',
    'orders',
    'reports',

    # must be the last app by documantation
    'django_cleanup.apps.CleanupConfig',

]

SITE_ID = config('SITE_ID')

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    'tracking.middleware.VisitorTrackingMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

CART_SESSION_ID = 'cart'


ROOT_URLCONF = 'solvergeek.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'ecommerce.context_processors.category',
                'cart.context_processors.cart',

            ],
        },
    },
]

WSGI_APPLICATION = 'solvergeek.wsgi.application'


# Database
# https://docs.djangoproject.com/en/2.1/ref/settings/#databases

# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.sqlite3',
#         'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
#     }
# }



# local posgress db
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'xtayconnectdb',
        'USER': 'postgres',
        'PASSWORD': 'aggrey123',
        'HOST': 'localhost',
        # 'PORT': '5432',
    }
}


prod_db = dj_database_url.config(conn_max_age=500)
DATABASES['default'].update(prod_db)


# Password validation
# https://docs.djangoproject.com/en/2.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


AUTHENTICATION_BACKENDS = (

    # Needed to login by username in Django admin, regardless of `allauth`
    'django.contrib.auth.backends.ModelBackend',

    # `allauth` specific authentication methods, such as login by e-mail
    'allauth.account.auth_backends.AuthenticationBackend',

)
# EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

ACCOUNT_EMAIL_REQUIRED = True
ACCOUNT_UNIQUE_EMAIL = True
ACCOUNT_EMAIL_VERIFICATION = 'none'
ACCOUNT_USERNAME_REQUIRED = True
ACCOUNT_AUTHENTICATION_METHOD = 'email'
ACCOUNT_SESSION_REMEMBER = 'yes'


LOGIN_REDIRECT_URL = 'index'
# LOGOUT_REDIRECT_URL = ''

LOGIN_URL = 'account_login'


# Internationalization
# https://docs.djangoproject.com/en/2.1/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/2.1/howto/static-files/


# DEFAULT_FILE_STORAGE = 'cloudinary_storage.storage.MediaCloudinaryStorage'


CRISPY_TEMPLATE_PACK = 'bootstrap4'

CKEDITOR_UPLOAD_PATH = 'content/ckeditor/'

CKEDITOR_CONFIGS = {
    'default': {
        'toolbar': 'full',
        'height': 600,
        'width': 700,
    },
}


STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

STATIC_ROOT = os.path.join(BASE_DIR, 'staticfile')
STATIC_URL = '/static/'
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'static')
]



THUMBNAIL_ALIASES = {
    '': {
        'avatar': {'size': (50, 50), 'crop': True},
    },
}


# CLOUDINARY_STORAGE = {
#     'CLOUD_NAME': config('CLOUD_NAME'),
#     'API_KEY': config('API_KEY'),
#     'API_SECRET': config('API_SECRET'),
# }



# working commented

# EMAIL_BACKEND = config('EMAIL_BACKEND')
# SENDGRID_API_KEY = config('SENDGRID_API_KEY')

EMAIL_HOST = 'smtp.sendgrid.net'
EMAIL_HOST_USER = 'apikey' # this is exactly the value 'apikey'
EMAIL_HOST_PASSWORD = config('SENDGRID_API_KEY')
EMAIL_PORT = 587
EMAIL_USE_TLS = True

# DIGITAL OCEAN SPACES
...
# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.11/howto/static-files/


# DEFAULT_FILE_STORAGE='storages.backends.s3boto3.S3Boto3Storage'

AWS_ACCESS_KEY_ID = config('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = config('AWS_SECRET_ACCESS_KEY')
AWS_STORAGE_BUCKET_NAME = config('AWS_STORAGE_BUCKET_NAME')
AWS_S3_ENDPOINT_URL = config('AWS_S3_ENDPOINT_URL')

AWS_S3_OBJECT_PARAMETERS = {
    'CacheControl': 'max-age=86400',
}
AWS_LOCATION = config('AWS_LOCATION')


STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'static'),
]


# STATIC_URL = 'https://%s/%s/' % (AWS_S3_ENDPOINT_URL, AWS_LOCATION)
# STATICFILES_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'

# MEDIA_URL = 'https://%s/%s/' % (AWS_S3_ENDPOINT_URL,'/media/')
# DEFAULT_FILE_STORAGE='storages.backends.s3boto3.S3Boto3Storage'



MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

MAPBOX_KEY =config('MOBOX_API_PRIVATE_TOKEN')  

LOCATION_FIELD = {
    'provider.google.api': '//maps.google.com/maps/api/js?sensor=false',
    'provider.google.api_key': config("GOOGLE_MAPS_API"),
    'provider.google.api_libraries': '',
    'provider.google.map.type': 'ROADMAP',
}

LOCATION_FIELD = {
    'map.provider': 'google',
}


CRONJOBS = [
    ('*/5 * * * *', 'ecommerce.crontab.my_scheduled_job'),
    ('*/5 * * * *', 'ecommerce.crontab.promotional_expire')

]

TRACK_IGNORE_STATUS_CODES = [400, 404, 403, 405, 410, 500]