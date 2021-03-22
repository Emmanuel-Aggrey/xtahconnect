import requests
import json
import pprint
from decouple import config
from django.shortcuts import redirect
import random

# This code will give you free fortnite vbucks
import webbrowser


# print(random.randint(10**12, 10**13 - 1))


def create_transaction_id():
    return random.randint(100000000000, 999999999999)
    # str(random.randint(10**12, 10**13 - 1))


def floatToMinor(amount):

    roundit = round(amount, 2)

    multiplyby100 = str(int(roundit * 100))

    minor = multiplyby100.zfill(12)
    return minor


def make_payment(customer_email, amount):
    payment_url = ''
    token = ''

    url = config('THETELLER_ENDPOINT')

    payload = {
        'merchant_id': config('THETELLER_MERCHANT_ID'),
        'transaction_id': create_transaction_id(),
        'desc': 'payment for a shoe',
        'amount': floatToMinor(amount),
        'redirect_url': config('THETELLER_MY_REDIRENT_URL'),
        'email': customer_email,
    }

    headers = {
        'Authorization': config('THETELLER_Authorization'),
        "Content-Type": "application/json",
        "Cache-Control": "no-cache",
    }

    response = requests.post(url, headers=headers,
                             data=json.dumps(payload), verify=False)
    callback = response.json()

    # transaction_id = payload['transaction_id']

    # print("transaction_id",transaction_id)


    values = {
        'payment_url': callback['checkout_url'], 'token': callback['token'],'transaction_id':payload['transaction_id']
    }
    
    # payment_url =
    # token = callback['token']
    return values

    # return webbrowser.open_new_tab(callback['checkout_url'])

    # return redirect(callback['checkout_url'])

    # print(values)


# solvergeek/the_teller_api.py

def verify_transaction(transaction_id):
    headers = {
        'Merchant-Id': config('THETELLER_MERCHANT_ID'),
        "Content-Type": "application/json",
        "Cache-Control": "no-cache",
    }
    
    response = requests.get(f'https://test.theteller.net/v1.1/users/transactions/{transaction_id}/status',headers=headers,verify=False)
    return response.json()

    