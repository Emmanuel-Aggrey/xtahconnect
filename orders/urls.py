from django.urls import  path
from . import views

app_name = 'orders'

urlpatterns = [
    path('checkout/', views.checkout, name='checkout'),
    path('checkout_success/',views.checkout_success,name='checkout_success'),
    path('checkout_fail/',views.checkout_fail,name='checkout_fail'),
    # path('checkout_success/',views.checkout_success,name='checkout_success'),
    path('make_payment_url/',views.make_payment_url,name='make_payment'),

    path("orders/",views.orders,name="orders"),
    path('order_items/<str:order_number>/<int:pk>/',views.order_items,name='order_items'),
    path('my_orders/',views.my_order_detail,name='my_order_detail'),

    path('ajax/load-cities/', views.load_cities, name='ajax_load_cities'),  # <-- this one here


]