from datetime import datetime
from .models import Product
def promotional_expire():
  todaay = datetime.today().strftime("%Y-%m-%d")
  expire = Product.objects.filter(is_promational=True)
  for items in expire:
      exp = expire.end_date.strftime('%Y-%m-%d')
      if exp < today:
          items.is_promational=False
          items.save()


def my_scheduled_job():
    print('my_scheduled_job is running')