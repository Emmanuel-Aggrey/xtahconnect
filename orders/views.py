# from solvergeek.settings import EMAIL_HOST_USER
import datetime

from cart.cart import Cart
from django.conf import settings
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.core.mail import send_mail, send_mass_mail
from django.db.models import Count, F, Q
from django.shortcuts import get_object_or_404, redirect, render,HttpResponse
from ecommerce.models import Product
from solvergeek.sendGrid_email import send_sendGredemail
from solvergeek.the_teller_api import make_payment
# from ecommerce.crontab import  python_requests
from django.http import JsonResponse
import  json
from .forms import OrderCreateForm#,City
from .models import Order, OrderItem, Staff_Email,City

# def great():

#     currentTime = datetime.datetime.now()
#     if currentTime.hour < 12:
#         return 'Good Morning'
#     elif 12 <= currentTime.hour < 18:
#         return 'Good afternoon'
#     else:
#         return 'Good Evening'

order_number_=[]
@login_required
def checkout(request):

    form = OrderCreateForm(request.POST or None)
    cart = Cart(request)
    # payment_method ='Online'
    customer_name = ''
    get_total_price =0
    url= ''
    if request.method == 'POST':
        customer_name = request.POST.get('name')
        customer_email = request.POST.get('email')
        customer_address = request.POST.get('address')
        customer_phone_number = request.POST.get('phone_number')
        customer_region = request.POST.get('region')
        customer_city = request.POST.get('city')
        user = request.user
        # order_payment = request.POST['order']
        payment_method = request.POST.get('payment_method')
        get_total_price = cart.get_total_price()

        orders = Order.objects.create(name=customer_name, phone_number=customer_phone_number,\
            user=user,email=customer_email,city_id=customer_city,address=customer_address,region_id=customer_region)

        order_number = orders.order_number
        customer_city =orders.city
        


              
        for item in cart:
            OrderItem.objects.create(
                order=orders,
                product=item['product'],
                price=item['price'],
                quantity=item['quantity'],
            )

        

                # get order email receivers
        order_email_recepients = Staff_Email.objects.values_list(
            'email', flat=True).filter(receive_order=True)

                # send mail to intended staff
        subject_staff = 'Hi'
        message_staff = f'Hello {customer_name} with contact number {customer_phone_number} from {customer_address}  (Google Map link) and close to {customer_city}, having order number {order_number}. \
        \n \t \n He prefers to pay {payment_method}. Please confirm, follow up and arrange dispatch. Thank You'

        recepient_staff = order_email_recepients
        email_from = 'Orders@xtayconnectafrica.com'
    

            # send mail to customers
        customer_subject ='Order From XtayconnectAfrica'
        customer_message = f'<strong>Dear Cherished Customer, <br> <br> Your Order has been placed successfully. We will call you soon! <br> <br> Please keep your Order Number <b style="font-size:bold">{order_number}</b> safe and thanks for shopping with us! <br> <br>  To view Your order(s), please click here <a href="https://xtayconnectafrica.com/my_orders/" target="_blank" rel="noopener noreferrer">My Order(s)</a></strong> <br>'
        html_content =customer_message
                
            # send the mail
        try:
            pass

            # send_mail(subject_staff, message_staff, email_from,recepient_staff, fail_silently=False)

                
            # customers
            # send_sendGredemail(customer_email,customer_subject,html_content)

            # cart.clear()           
        except:
            pass

        return JsonResponse({"order_number":order_number})
                    
          
             
        form = OrderCreateForm()
    return render(request, 'order/checkoout.html', {'form': form})

  


def checkout_payment(request,order_number):
    
    if request.method == 'POST':
        payment_method = request.POST.get('payment_method')
        cart = Cart(request)
        order = Order.objects.get(user=request.user,order_number=order_number)


        customer_name = order.name
        customer_email = order.email
        customer_address = order.address
        customer_phone_number = order.phone_number
        customer_region = order.region
        customer_city = order.city
        order_number = order.order_number
    
        amount = cart.get_total_price()
      

        # print(payment_method)
        order.payment_method =payment_method
        order.save()



       

        payment_url_= ''
        if payment_method == 'Online Payment':
            
            make_payment_ = make_payment(customer_email,amount)
           

            payment_url_ =make_payment_.get('payment_url')
            # del request.session['payment_url']
            request.session['payment_url'] = payment_url_
            #token =make_payment_.get('token')
            transaction_id = make_payment_.get('transaction_id')
            order.transaction_id = transaction_id
            order.save()
       

                # get order email receivers
        order_email_recepients = Staff_Email.objects.values_list(
            'email', flat=True).filter(receive_order=True)

                # send mail to intended staff
        subject_staff = 'Hi'
        message_staff = f'Hello {customer_name} with contact number {customer_phone_number} from {customer_address}  (Google Map link) and close to {customer_city}, having order number {order_number}. \
        \n \t \n He prefers to pay  {payment_method}. Please confirm, follow up and arrange dispatch. Thank You'

        recepient_staff = order_email_recepients
        email_from = 'Orders@xtayconnectafrica.com'
    

            # send mail to customers
        customer_subject ='Order From Xtayconnect Africa'
        customer_message = f'<strong>Dear Cherished Customer, <br> <br> Your Order has been placed successfully. We will call you soon! <br> <br> Please keep your Order Number <b style="font-size:bold">{order_number}</b> safe and thanks for shopping with us! <br> <br>  To view Your order(s), please click here <a href="https://xtayconnectafrica.com/my_orders/" target="_blank" rel="noopener noreferrer">My Order(s)</a></strong> <br>'
        html_content =customer_message



        try:
            send_mail(subject_staff, message_staff, email_from,recepient_staff, fail_silently=False)

                
            # customers
            send_sendGredemail(customer_email,customer_subject,html_content)

                      
        except:
            pass
        
        cart.clear() 


        payment_url ={
        "payment_url":request.session['payment_url'],
         }
    
        if payment_method == 'Online Payment':
            return JsonResponse(payment_url,safe=False)
        else: 
            return HttpResponse()



def checkout_success(request):
  
    return render(request, 'order/checkoout_success.html')


def checkout_fail(request):
    return render(request, 'order/checkout_fail.html')


@login_required
def orders(request):
    order_items = Order.objects.all()
    q = request.GET.get('q')
    if q:
        order_items = order_items.filter(
            Q(name__icontains=q) | Q(order_number__icontains=q))

    # print(order_items)
    context = {
        'order_items': order_items,
    }
    return render(request, 'order/order.html', context)


@login_required
def order_items(request, order_number, pk):
    orders = get_object_or_404(Order, order_number=order_number, pk=pk)

    # order_item = orders.items.all()
    # for x in order_item:

    #     print(order_item)

    context = {
        'orders': orders,
        # 'order_items':order_items,
    }
    return render(request, 'order/orderitems.html', context)


@login_required
def my_order_detail(request):
    orders = Order.objects.filter(user=request.user)
    order_size= orders.aggregate(orders_size=Count('items'))

    context = {
        'orders': orders,
        'order_size':order_size,
    }

    return render(request, 'order/my_order_details.html', context)


def load_cities(request):
    region_id = request.GET.get('region')
    cities = City.objects.filter(region_id=region_id).order_by('name')
    return render(request, 'order/city_dropdown_list_options.html', {'cities': cities})