from django.utils import timezone
from .models import Product
def promotional_expire():
  today = timezone.now() 
  expire = Product.objects.filter(is_promational=True,end_date=today).update(is_promational=False)
#   for items in expire:
#       exp = expire.end_date.strftime('%Y-%m-%d')
#       if exp < today:
#           items.is_promational=False
#           items.save()


def my_scheduled_job():
    print('my_scheduled_job is running')

