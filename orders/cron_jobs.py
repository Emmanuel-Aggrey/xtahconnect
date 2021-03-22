from django.utils import timezone
from . models import Order
from solvergeek.the_teller_api import verify_transaction

def verify_transaction_save():
    today = timezone.now()
    orders = Order.objects.filter(paid=False,date_add__date=today,payment_method='Online',transaction_id__isnull=False).only('transaction_id','paid')
    for transaction_ids in orders:
        # call the api and verify trasnaction
        verify_transactions = verify_transaction(transaction_ids.transaction_id)
        platform = verify_transactions['r_switch']
        currency = verify_transactions['currency']
        status = verify_transactions['status']

        # print([platform, currency, status])

        if status == 'approved':
            orders.update(paid=True,payment_method=[platform,currency,status,'Online'])
        # elif status == 'failed':
        #     orders.update(paid=False)

    return orders


        # print(transaction_ids.transaction_id)





# orders/cron_jobs.py