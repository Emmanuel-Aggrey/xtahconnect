from django.contrib import admin
from .models import Product,Category,Sub_Category
from orders.models import OrderItem
# Register your models here


admin.site.site_header = "XTAYCONNECT AFRICA" # Add this



class Sub_CategoryInline(admin.TabularInline):
    model = Sub_Category
    list_display = ['category','name','is_available']
    list_editable = ['is_available',]
    list_filter = ['is_available','category']


class CategoryAdmin(admin.ModelAdmin):
    inlines = [Sub_CategoryInline]
    list_display = ['name','is_available',]
    list_editable = ['is_available',]
    extra=3

class ProductInline(admin.TabularInline):
    model = Product
    list_display = ['category','name','price','is_available']
    list_filter = ['category','is_available']
    fieldsets = (
        (None, {
            'fields': ('category','name', 'price','image','is_available','description',)
        }),
        ('MORE IMAGES', {
            'classes': ('collapse',),
            'fields': ('image1', 'image2','image3','image4','image5',),
        }),
        
    )
    list_editable = ['is_available',]






class ProductAdminInline(admin.ModelAdmin):
    list_display = ['category','name','is_available']
    inlines = [ProductInline]
    list_editable = ['is_available',]

   
class ProductAdmin(admin.ModelAdmin):
    list_display = ['category','name','price','is_available']
    list_editable = ['is_available',]
    list_filter = ['is_available','is_promational']

    fieldsets = (
        (None, {
            'fields': ('category','name', 'price','image','is_available','description',)
        }),
        ('MORE IMAGES', {
            'classes': ('collapse',),
            'fields': ('image1', 'image2','image3','image4','image5',),
        }),
         ('Run Promotion', {
            'classes': ('collapse',),
            'fields': ('text', 'discount_price','from_date','to_date',),
        }),

    )



admin.site.register(Category,CategoryAdmin)
admin.site.register(Sub_Category,ProductAdminInline)
admin.site.register(Product,ProductAdmin)