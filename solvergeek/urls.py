"""solvergeek URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls import handler404, handler500
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path
from django.views.generic import TemplateView

urlpatterns = [
    # path('ecommerce/',include('ecommerce.urls')),
    path('', include('ecommerce.urls')),
    path('xconnect/', admin.site.urls),
    path('accounts/', include('allauth.urls')),
    path('', include('orders.urls')),
    path('', include('cart.urls')),
    path('', include('reports.urls')),
    path('ckeditor/', include('ckeditor_uploader.urls')),
    path('terms_and_conditions/', TemplateView.as_view(
        template_name='terms_and_conditions.html'), name='termsandconditions'),
    path('return_policy/', TemplateView.as_view(template_name='return_policy.html'),
         name='returnpolicy'),


]#+static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

if settings.DEBUG:
    urlpatterns += static(
        settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
elif getattr(settings, 'FORCE_SERVE_STATIC', False):
    settings.DEBUG = True
    urlpatterns += static(
        settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(
        settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    settings.DEBUG = False

# urlpatterns+=static(settings.MEDIA_ROOT,document_root=settings.MEDIA_ROOT)

# handler404 = 'ecommerce.views.error404'
# handler500 = 'ecommerce.views.error500'
