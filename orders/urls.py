from django.urls import  path
from . import views

app_name = 'orders'

urlpatterns = [
    path('checkout/', views.checkout, name='checkout'),
    path('payment-success/',views.payment_success,name='payment_success'),
    path('checkout_fail/',views.checkout_fail,name='checkout_fail'),

    path("orders/",views.orders,name="orders"),
    path('order_items/<str:order_number>/<int:pk>/',views.order_items,name='order_items'),

]