from django.urls import  path
from . import views

app_name = 'orders'

urlpatterns = [
    path('checkout/', views.checkout, name='checkout'),
    path('payment-success/',views.payment_success,name='payment_success'),
    path('checkout_fail/',views.checkout_fail,name='checkout_fail'),
    path('payment_success/',views.payment_success,name='payment_success'),

    path("orders/",views.orders,name="orders"),
    path('order_items/<str:order_number>/<int:pk>/',views.order_items,name='order_items'),
    path('my_orders/',views.my_order_detail,name='my_order_detail'),

]