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

import requests
def python_requests():
   
    import requests

    url = "https://test.theteller.net/checkout/initiate"

    payload={'merchant_id': 'TTM-00005159',
    'transaction_id': '123456789012',
    'desc': 'payment for a shoe',
    'amount': '100',
    'redirect_url': 'https://xtayconnectafrica.com/checkout_success/',
    'email': 'aggrey.en@live.com'}
    files=[

    ]
    headers = {
    'Authorization': 'Basic eHRheWNvbm5lY3RhZnJpY2E2MDJhMmY1ODhhMDFkOk1EWTNOV1k0T1RSa01HWm1PVGczTkdFNFpqVTRZems1TnpFeE4yWXdPR0k9',
    "content-type":"application/json",
    "Cache-Control":"no-cache",
    'Cookie': 'XSRF-TOKEN=eyJpdiI6InVJb1Y5cUJhSjFPNHB4d1NGdHMxeWc9PSIsInZhbHVlIjoiTWJlUmQ4U1JBZjVQWUt2NUJXSU5UYWVWYSt0Q2dQVWJodlhUWHRwNlJQdFwvdzNPVEFNTnhySUJvTUhQNWpSc00iLCJtYWMiOiIxNjJiOGQ2YmQ1MGRiYzY1NzMzZTg5YWJjNDQ3ZmIwZTlmOGNkZWJiNTRiNGFkMGI3M2RjMjU0OTA5ZDk1OGMyIn0%3D; theteller_checkout_session=eyJpdiI6InkxQm9IdEhLd0lyWWVyUzlVZ2UxZkE9PSIsInZhbHVlIjoieGJ6OENNN2NWUVU4VVdabUkzOGNYYUlWZ0J4TStWNndNcEFoM0FQaXIxbWtyS3NpWGNITGI0VHVsZVhnWkt0YyIsIm1hYyI6IjgzNTRiODY1MDAyYTFiNWRjMjE2OTM3YWQwMzFmZTYxZDI2MGFmOWE1ZDliMzU4ZmE3ZDRlZmY4YjlhZWEwZTIifQ%3D%3D'
    }

    response = requests.request("POST", url, headers=headers, data=payload, files=files)

    print(response.text)



