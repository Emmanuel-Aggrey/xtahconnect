from django.urls import  path
from . import views

app_name = 'reports'
urlpatterns = [
    path('customers/',views.customers_data,name='customers'),
    path('customers_order_detail/<int:id>/',views.customers_order_detail,name='customers_order'),
    path('product_report/',views.product_report,name='product_report'),
    path('products_report_detail/<str:name>/',views.products_report_detail,name='products_report_detail'),
    path('products_remaiaining_detail/<str:name>/',views.products_remaiaining_detail,name='products_remaiaining_detail'),

]