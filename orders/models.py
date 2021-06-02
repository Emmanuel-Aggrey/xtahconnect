import datetime

from django.contrib.auth.models import User
from django.core.validators import RegexValidator
from django.db import models
from django.db.models import F, Sum
from django.db.models.signals import post_save
from django.dispatch import receiver
from ecommerce.models import Base_Model, Product
from hashids import Hashids
from mapbox_location_field.models import LocationField
# from mapbox_location_field.spatial.models import SpatialLocationField  
from location_field.models.plain import PlainLocationField
# Create your models here.
hashids = Hashids()
from random import randint


class Staff_Email(Base_Model):
    
    name = models.ForeignKey(User,on_delete=models.CASCADE,limit_choices_to={'is_staff': True})
    email = models.EmailField()
    receive_order = models.BooleanField(default=True)
 


    class Meta:
        verbose_name = 'staff Email'
        verbose_name_plural='staff Emails'
    
    def __str__(self):
        return f'{self.name.username,self.email}'

class Region(Base_Model):
    name = models.CharField(max_length=200,unique=True)
    def __str__(self):
        return self.name

    class  Meta:
        ordering = ['name']

class City(Base_Model):
    region=models.ForeignKey(Region,on_delete=models.CASCADE,null=True)
    name = models.CharField(max_length=200)

  

    def __str__(self):
        return f"{self.name} in {self.region}"
    
    class Meta:
        verbose_name = 'City'
        verbose_name_plural= 'Cities'
        ordering = ['name']


class Delevery_Status(Base_Model):
    name = models.CharField(max_length=600,default='Order Placed')

    class Meta:
        verbose_name = "Delevery Status"
        verbose_name_plural ='Delevery Status'
    
    def __str__(self):
        return self.name


class Pickupstation(Base_Model):
    name = models.CharField(max_length=600)

class Order(Base_Model):
    user =models.ForeignKey(User,on_delete=models.CASCADE,related_name='user')
    name = models.CharField(max_length=8000)
    email = models.EmailField()
    address = models.TextField(null=True)
    phone_number = models.CharField(max_length=15, blank=False)
    delevery_Status = models.ForeignKey(Delevery_Status,on_delete=models.CASCADE,null=True,blank=True)
    # city = models.CharField('City/Closest Landmark',max_length=600)
    
    region =models.ForeignKey(Region,on_delete=models.CASCADE,null=True,blank=True)
    city =models.ForeignKey(City,null=True,on_delete=models.CASCADE,blank=True)
    paid = models.BooleanField(default=False)
    order_number = models.CharField('order number',max_length=500,editable=False)
    location = LocationField(null=True,blank=True)  
    payment_method =models.CharField(max_length=255,null=True,blank=True,editable=False)

    city1 = models.CharField(max_length=255,null=True,blank=True)
    location_google = PlainLocationField(based_fields=['city1'], zoom=7,null=True,blank=True)
    transaction_id =models.CharField(max_length=200,null=True,blank=True)
    pickupstation = models.ForeignKey(Pickupstation,on_delete=models.CASCADE,blank=True,null=True)
    




    class Meta:
        ordering = ('-date_updated', )

    def __str__(self):
        return 'Order {}'.format(self.id)

    def get_total_cost(self):
    
        return sum(item.get_cost() for item in self.items.all())
    def __str__(self):
        return f'user: {self.user.username} order umber : {self.order_number}'
    
    def gettotal_oders(self):
        # print(len(self.order_number))
        return len(self.order_number)
    




def random_with_N_digits(n):
    range_start = 10**(n-1)
    range_end = (10**n)-1
    return randint(range_start, range_end)

# print (random_with_N_digits(2))

@receiver(post_save,sender=Order)
def create_orders_number(sender,instance,created,*args, **kwargs):
    # now = datetime.datetime.now().strftime("%Y%m%d%H%M")
    if not instance.order_number:
        
        # order_id = hashids.encrypt(instance.id)
        ordernummber= str(random_with_N_digits(8))#+''+str(order_id)
        instance.order_number = ordernummber
        instance.save()

    # print('ordernummber ',ordernummber)



class OrderItem(Base_Model):
    order = models.ForeignKey(Order, related_name='items', on_delete=models.CASCADE)
    product = models.ForeignKey(Product, related_name='order_items', on_delete=models.CASCADE)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.PositiveIntegerField(default=1)

    def __str__(self):
        return '{}'.format(self.order.name)

    def get_cost(self):
        if self.price and self.quantity:
            
            return self.price * self.quantity
        else:
            return None


    def grand_total(self):
        return self.get_cost
      



@receiver(post_save,sender=OrderItem)
def subtract_stock(sender,instance,created,*args, **kwargs):
    if created:
        # print('instance signal',instance.product.name,'quantity',instance.quantity)

        products = Product.objects.filter(name=instance.product.name).update(
            quantity=F('quantity')-instance.quantity)
        
    if  instance.product.quantity <=0:
        print('instance signal',instance.product.name,'quantity',instance.product.quantity)
