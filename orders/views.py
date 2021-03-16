# from solvergeek.settings import EMAIL_HOST_USER
import datetime

from cart.cart import Cart
from django.conf import settings
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.core.mail import send_mail, send_mass_mail
from django.db.models import Count, F, Q
from django.shortcuts import get_object_or_404, redirect, render
from ecommerce.models import Product
from solvergeek.sendGrid_email import send_sendGredemail

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


@login_required
def checkout(request):

    form = OrderCreateForm(request.POST or None)
    cart = Cart(request)
    # if Order.objects.values('name','address','phone_number','address').filter(user__username=request.user).exists():
    #     user_last_info= Order.objects.values('name','address','phone_number','address').filter(user__username=request.user).last()
    #     print(user_last_info)
       
  


    #     form.fields['email'].initial=request.user.email
    #     form.fields['name'].initial=user_last_info['name']
    #     form.fields['address'].initial=user_last_info['address']
    #     # form.fields['region'].initial=user_last_info['region']
    #     form.fields['phone_number'].initial=user_last_info['phone_number']
    #     # form.fields['city'].initial=user_last_info['city']



    if request.method == 'POST':
        customer_name = request.POST.get('name')
        customer_email = request.POST.get('email')
        customer_address = request.POST.get('address')
        customer_phone_number = request.POST.get('phone_number')
        customer_region = request.POST.get('region')
        customer_city = request.POST.get('city')
        user = request.user
        # demo = request.POST.get('demo')
        # print('demo is ',demo)

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
        \n \t \n He prefers to pay through (Payment Method). Please confirm, follow up and arrange dispatch. Thank You'

        recepient_staff = order_email_recepients
        email_from = 'Orders@xtayconnectafrica.com'
    

            # send mail to customers
        customer_subject ='Order From XtayconnectAfrica'
        customer_message = '<strong>Dear Cherished Customer, <br> <br> Your Order has been placed successfully. We will call you soon! <br> <br> Please keep your Order Number safe and thanks for shopping with us! <br> <br>  To view Your order(s), please click here <a href="https://xtayconnectafrica.com/my_orders/" target="_blank" rel="noopener noreferrer">My Order(s)</a></strong> <br>'
        html_content =customer_message
                
            # send the mail
        try:

            send_mail(subject_staff, message_staff, email_from,recepient_staff, fail_silently=False)

                
            # customers
            send_sendGredemail(customer_email,customer_subject,html_content)


            cart.clear()
            request.session['order_number'] =order_number

                    
            return redirect('orders:checkout_success')
        except:
            pass
                    
            # staff

            
        
            # form = OrderCreateForm()
                   
        # return render(request, 'order/checkoout_success.html')
    # else:
        form = OrderCreateForm()
    return render(request, 'order/checkoout.html', {'form': form})


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