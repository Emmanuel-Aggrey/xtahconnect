import datetime

from django.core.validators import RegexValidator
from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver
from ecommerce.models import Base_Model, Product
from hashids import Hashids

# Create your models here.
hashids = Hashids()


class Order(Base_Model):
    name = models.CharField(max_length=60)
    email = models.EmailField()
    address = models.CharField(max_length=150)
    # phone_regex = RegexValidator(regex=r'^\+?1?\d{9,15}$', message="Phone number must be entered in the format: '+233'. Up to 15 digits allowed.")
    phone_number = models.CharField(max_length=15, blank=False)
    city = models.CharField('City/Closest Landmark',max_length=100)
    # created = models.DateTimeField(auto_now_add=True)
    # updated = models.DateTimeField(auto_now=True)
    paid = models.BooleanField(default=False)
    order_number = models.CharField('order number',max_length=500,editable=False)

    class Meta:
        ordering = ('-date_updated', )

    def __str__(self):
        return 'Order {}'.format(self.id)

    def get_total_cost(self):
    
        return sum(item.get_cost() for item in self.items.all())


@receiver(post_save,sender=Order)
def create_orders_number(sender,instance,created,*args, **kwargs):
    now = datetime.datetime.now().strftime("%Y%m%d%H%M")
    if not instance.order_number:
        order_id = hashids.encrypt(instance.id)
        ordernummber= now+'-'+str(order_id)
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
        print(sum(self.get_cost))
        return sum(self.get_cost)

