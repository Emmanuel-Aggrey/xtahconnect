from django.contrib import admin
from .models import Order, OrderItem,Staff_Email,City,Region,Delevery_Status

from mapbox_location_field.admin import MapAdmin  
from mapbox_location_field.spatial.admin import SpatialMapAdmin  
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
    
    


class CityInline(admin.TabularInline):
    model = City
    list_display = ['city','name']


   
    # raw_id_fields = ['product']


class RegionAdmin(admin.ModelAdmin):
    list_display = ['name']
    inlines = [CityInline]
    search_fields = ('name',)
 

# admin.site.register(Order, OrderAdmin)
admin.site.register(Order, SpatialMapAdmin)  
admin.site.register(Region, RegionAdmin)

admin.site.register(Delevery_Status)


class ReceivedOrder(admin.ModelAdmin):
    list_display=['name', 'email','receive_order']
    list_editable = ['receive_order',]

admin.site.register(Staff_Email,ReceivedOrder)





# admin.site.register(OrderItem)
