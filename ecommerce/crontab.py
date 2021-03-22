from django.utils import timezone
from .models import Product,Reminder
def promotional_expire():
  today = timezone.now() 
  expire = Product.objects.filter(end_date__lte=today,is_promational=True).update(is_promational=False)
  return expire
#   for items in expire:
#       exp = expire.end_date.strftime('%Y-%m-%d')
#       if exp < today:
#           items.is_promational=False
#           items.save()


def promotional_start():
  today = timezone.now() 
  expire = Product.objects.filter(start_date__date=today,is_promational=False).update(is_promational=True)
  return expire

def check_out_of_stock():
      Product.objects.filter(quantity__lte=0).update(is_available=False)
    
# def stock_updated():
#       Product.objects.filter(quantity__gte=1).update(is_available=True)
    

# ecommerce/crontab.py