from django.contrib import admin
from .models import Order, OrderItem


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    raw_id_fields = ['product']


class OrderAdmin(admin.ModelAdmin):
    list_display = ['user','order_number', 'name','email', 'address', 'phone_number', 'city', 'paid',]
    list_filter = ['paid',]
    inlines = [OrderItemInline]
    search_fields = ('order_number','email','phone_number','name')
    list_editable = ['paid']
    list_display_links = ['order_number','email','name',]


admin.site.register(Order, OrderAdmin)



