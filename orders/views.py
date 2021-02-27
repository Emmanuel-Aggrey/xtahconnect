from cart.cart import Cart
from django.conf import settings
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.core.mail import send_mail, send_mass_mail
from django.db.models import Q
from django.shortcuts import get_object_or_404, redirect, render
# from solvergeek.settings import EMAIL_HOST_USER
import datetime
from .forms import OrderCreateForm
from .models import Order, OrderItem, Staff_Email
from solvergeek.sendGrid_email import  send_sendGredemail

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

    cart = Cart(request)
    if request.method == 'POST':
        form = OrderCreateForm(request.POST)
        if form.is_valid():

            order = form.save(commit=False)
            order.user = request.user
            order.save()
            order_number = order.order_number
            order_id = order.id

            #
            # subject = 'order placed'
            # message = ' A customer just sent a request to purchase a product get to admin for more info '
            # email_from = settings.EMAIL_HOST_USER
            # recipient_list = ['aggrey.en@live.com',]
            # send_mail( subject, message, email_from, recipient_list,fail_silently=False )

            for item in cart:
                OrderItem.objects.create(
                    order=order,
                    product=item['product'],
                    price=item['price'],
                    quantity=item['quantity'],
                )

                # for key, value in request.POST.items():
                # pass

                alldate = form.cleaned_data
                customer_name = form.cleaned_data.get('name')
                customer_email = form.cleaned_data.get('email')
                customer_address = form.cleaned_data.get('address')
                customer_phone_number = form.cleaned_data.get('phone_number')
                customer_city = form.cleaned_data.get('city')

                # subject = 'order placed'
                # message = ' A customer just sent a request to purchase a product get to admin for more info '
                # recepient = [customer_email]
                # email_from = settings.EMAIL_HOST_USER
                # send_mail(message,
                # 'order number is {} search for the items with this order number. Customer Name is {} and phone is :{} from {}'.format(order_number,name,phone_number,city), EMAIL_HOST_USER, ['aggrey.en@live.com',recepient], fail_silently = False)

                # print(first_name,email,address,phone_number,city)

                # get order email receivers
                order_email_recepients = Staff_Email.objects.values_list(
                    'email', flat=True).filter(receive_order=True)

                # send mail to intended staff
                subject_staff = 'Hi'
                message_staff = f'Hello {customer_name} with contact number {customer_phone_number} from {customer_address} plus (Google Map link) and close to {customer_city} having order number {order_number} \
                   \n He prefers to pay through (Payment Method). Please confirm, follow up and arrange dispatch. Thank You'

                recepient_staff = order_email_recepients
                email_from = 'Orders@xtayconnectafrica.com'
                

                # send mail to customers
                customer_subject ='Dear Client'
                html_content ='<strong>Your Order has been placed successfully. We will call you soon! Please keep your Order Number safe and thanks for shopping with us \
                    To view Your order(s). Please click here. <a href="https://xtayconnectafrica.com/my_orders/" target="_blank" rel="noopener noreferrer">My Order(s)</a></strong>'
                
                # send the mail
                if order_email_recepients:
                    
                    # staff
                    send_mail(subject_staff, message_staff, email_from,recepient_staff, fail_silently=False)

                
                    # customers
                    send_sendGredemail(customer_email,customer_subject,html_content)
               

                    cart.clear()
                    request.session['order_number'] =order_number
                    return redirect('orders:checkout_success')
                else:
                    pass
                   
        return render(request, 'order/checkoout_success.html', {'order': order})
    else:
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

    context = {
        'orders': orders,
    }

    return render(request, 'order/my_order_details.html', context)
