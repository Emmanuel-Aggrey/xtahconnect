from django.db import models
from django.core.validators import RegexValidator
from ecommerce.models import Product
import datetime
from ecommerce.models import Base_Model




def increment_order_number():
  last_order = Order.objects.all().order_by('id').last()
  if not last_order:
    return '' + str(datetime.date.today().year) + str(datetime.date.today().month).zfill(2) + '0000'
  order_number = last_order.order_number
  order_int = int(order_number[9:13])
  new_order_int = order_int + 1
  new_order_id = '' + str(str(datetime.date.today().year)) + str(datetime.date.today().month).zfill(2) + str(new_order_int).zfill(4)
  return new_order_id

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
    order_number = models.CharField('order number',max_length=500,editable=False,default=increment_order_number)

    class Meta:
        ordering = ('-date_updated', )

    def __str__(self):
        return 'Order {}'.format(self.id)

    def get_total_cost(self):
    
        return sum(item.get_cost() for item in self.items.all())


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

