from django.conf.urls import url
from django.urls import  path
from . import views

app_name = 'cart'

urlpatterns = [
    path('yourcart', views.cart_detail, name='cart_detail'),
    path('add/<int:product_id>/', views.cart_add, name='cart_add'),
    path('remove/<int:product_id>/', views.cart_remove, name='cart_remove'),
    path("cart_size/",views.cart_size, name="cart_size"),

    path('detail/',views.detail),
]

