from django.contrib import admin
from .models import Product,Category,Sub_Category
from orders.models import OrderItem
# Register your models here


admin.site.site_header = "XTAYCONNECT AFRICA" # Add this


class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name','is_available',]
    list_editable = ['is_available',]




class Sub_CategoryAdmin(admin.ModelAdmin):
    list_display = ['category','name','is_available']
    list_editable = ['is_available',]

class ProductAdmin(admin.ModelAdmin):
    list_display = ['category','name','price','is_available']

    list_filter = ['category','is_available']
    list_editable = ['is_available',]

    fieldsets = (
        (None, {
            'fields': ('category','name', 'price','image','is_available','description',)
        }),
        ('MORE IMAGES', {
            'classes': ('collapse',),
            'fields': ('image1', 'image2','image3','image4','image5',),
        }),
    )




admin.site.register(Category,CategoryAdmin)
admin.site.register(Sub_Category,Sub_CategoryAdmin)
admin.site.register(Product,ProductAdmin)
