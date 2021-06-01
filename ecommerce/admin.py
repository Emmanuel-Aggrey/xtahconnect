from django.contrib import admin
from .models import Product,Category,Sub_Category,Reminder,Launching
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
    list_display = ['category','name','quantity','price','discount','discount_price','percentageoff','is_available','is_promational']
    list_filter = ['category','is_available']
    fieldsets = (
        (None, {
            'fields': ('category','name','quantity', 'price','discount','image','is_available','description',)
        }),
        #  ('Add Descount', {
        #     'classes': ('collapse',),
        #     'fields': ('discount',),
        # }),
        ('MORE IMAGES', {
            'classes': ('collapse',),
            'fields': ('image1', 'image2','image3','image4','image5',),
        }),
        
    )
    list_editable = ['is_available','is_promational']






class ProductAdminInline(admin.ModelAdmin):
    list_display = ['category','name','is_available',]
    inlines = [ProductInline]
    list_editable = ['is_available',]

   
class ProductAdmin(admin.ModelAdmin):
    list_display = ['category','name','quantity','price','discount','discount_price','percentageoff','is_available','is_promational']
    list_editable = ['is_available','discount','is_promational']
    list_filter = ['is_available','is_promational']

    fieldsets = (
        (None, {
            'fields': ('category','name','quantity','price','discount','image','is_available','description',)
        }),
        # ('Add Descount', {
        #     'classes': ('collapse',),
        #     'fields': ('discount',),
        # }),
        ('MORE IMAGES', {
            'classes': ('collapse',),
            'fields': ('image1', 'image2','image3','image4','image5',),
        }),
        #  ('Run Promotion', {
        #     'classes': ('collapse',),
        #     'fields': ('text', 'discount_price','start_date','end_date','is_promational'),
        # }),

    )



class Display_Reminder(admin.ModelAdmin):
    # pass
    # list_display=['stock_size']
    # list_editable = ['stock_size']

    def has_add_permission(self,request):
        return False if self.model.objects.count() > 0 else super().has_add_permission(request) 




admin.site.register(Launching)
admin.site.register(Reminder,Display_Reminder)

admin.site.register(Category,CategoryAdmin)
admin.site.register(Sub_Category,ProductAdminInline)
admin.site.register(Product,ProductAdmin)