from django.contrib import admin
from .models import Order, OrderItem,Staff_Email,Region#,City
from mapbox_location_field.admin import MapAdmin  
  

class OrderItemInline(admin.TabularInline):
    model = OrderItem
    raw_id_fields = ['product']


class OrderAdmin(admin.ModelAdmin):
    list_display = ['user','order_number', 'name','email', 'address', 'phone_number','paid']
    # list_display = ['user','order_number', 'name','email', 'address', 'phone_number','paid','location']

    list_filter = ['paid',]
    inlines = [OrderItemInline]
    search_fields = ('order_number','email','phone_number','name')
    list_editable = ['paid']
    list_display_links = ['order_number','email','name',]
    
    


# class CityInline(admin.TabularInline):
#     model = City
#     list_display = ['city','name']


   
#     # raw_id_fields = ['product']


# class RegionAdmin(admin.ModelAdmin):
#     list_display = ['name']
#     inlines = [CityInline]
#     search_fields = ('name',)
 


# admin.site.register(Order, MapAdmin)  

admin.site.register(Region)
admin.site.register(Order, OrderAdmin)

admin.site.register(Region, RegionAdmin)



class ReceivedOrder(admin.ModelAdmin):
    list_display=['name', 'email','receive_order']
    list_editable = ['receive_order',]

admin.site.register(Staff_Email,ReceivedOrder)





# admin.site.register(OrderItem)
