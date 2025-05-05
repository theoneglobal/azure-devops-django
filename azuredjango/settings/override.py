from opencensus.ext.azure.log_exporter import AzureLogHandler
from azuredjango.settings import *
from django.urls import path, include
import os

# Media and static file settings
MEDIA_ROOT = os.getenv("DJANGO_MEDIA_ROOT", "/home/docker/app/media")
MEDIA_URL = "/media/"

STATIC_ROOT = os.getenv("DJANGO_STATIC_ROOT", "/home/docker/app/staticfiles")
STATIC_URL = "/static/"

# Additional apps
INSTALLED_APPS += [
    "health_check",
    "health_check.db",
    "health_check.cache",
    "health_check.storage",
    "health_check.contrib.migrations",
]

# Logging configuration
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "verbose": {
            "format": "%(asctime)s [%(levelname)s] %(module)s: %(message)s",
            "datefmt": "%Y-%m-%d %H:%M:%S",
        }
    },
    "handlers": {
        "console": {
            "level": "DEBUG",
            "class": "logging.StreamHandler",
            "formatter": "verbose",
        },
        "azure": {
            "level": "INFO",
            "class": "opencensus.ext.azure.log_exporter.AzureLogHandler",
            "instrumentation_key": os.getenv("AZURE_APP_INSIGHTS_KEY"),
            "formatter": "verbose",
        },
    },
    "loggers": {
        "django": {
            "handlers": ["console", "azure"],
            "level": "DEBUG",
            "propagate": True,
        },
        "django.request": {
            "handlers": ["console", "azure"],
            "level": "WARNING",
            "propagate": False,
        },
        "django.db.backends": {
            "handlers": ["console", "azure"],
            "level": "WARNING",
            "propagate": False,
        },
    },
}

# Azure Storage settings
DEFAULT_FILE_STORAGE = "storages.backends.azure_storage.AzureStorage"
STATICFILES_STORAGE = "storages.backends.azure_storage.AzureStorage"

# Additional middleware
MIDDLEWARE += ["django.middleware.common.CommonMiddleware"]

# URL configuration override
urlpatterns = [
    path("admin/", admin.site.urls),
    path("health/", include("health_check.urls")),
]
