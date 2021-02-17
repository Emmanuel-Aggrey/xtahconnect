from cart.cart import Cart
from django.conf import settings
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.core.mail import send_mail, send_mass_mail
from django.db.models import Q
from django.shortcuts import get_object_or_404, redirect, render
from solvergeek.settings import EMAIL_HOST_USER

from .forms import OrderCreateForm
from .models import Order, OrderItem


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
                name = form.cleaned_data.get('name')
                customer_email = form.cleaned_data.get('email')
                address = form.cleaned_data.get('address')
                phone_number = form.cleaned_data.get('phone_number')
                city = form.cleaned_data.get('city')
                
                # subject = 'order placed'
                # message = ' A customer just sent a request to purchase a product get to admin for more info '
                # recepient = [customer_email]
                # email_from = settings.EMAIL_HOST_USER
                # send_mail(message, 
                # 'order number is {} search for the items with this order number. Customer Name is {} and phone is :{} from {}'.format(order_number,name,phone_number,city), EMAIL_HOST_USER, ['aggrey.en@live.com',recepient], fail_silently = False)
            
                # print(first_name,email,address,phone_number,city)
                
                #send  mass email
                # email_from = settings.EMAIL_HOST_USER
                # message1 = ('Hello aggrey ', f'a customer with phone { phone_number } and name { name } from {city} having { order_number } as order number had ordered for a product sign in to admin for more info use the phone,email,name order number to search', email_from, ['aggrey.en@live.com','aggrey.en@gmail.com',])
                # message2 = ('Hello ' f'{ name } your order number is {order_number}','\n\tOrder placed successfully we will call u soon please keep the order number safe. Thanks for shopping with us', email_from, [customer_email])
                # try:
                #     send_mass_mail((message1, message2), fail_silently=False)

                # except:
                #     messages.info(request,f'email not sent but your order was placed successfully your order number is\t<h4><b><u>{order_number}</u></b></h4>\tkindly feel free to give us a call on\
                #     <b>0240699506</b> please keep the order number safe')
                #     cart.clear()
                #     return redirect('orders:checkout')

          
            cart.clear()
        return render(request, 'order/checkoout_success.html', {'order': order})
    else:
        form = OrderCreateForm()
    return render(request, 'order/checkoout.html', {'form': form})


def payment_success(request):
    return render(request,'order/checkoout_success.html')


def checkout_fail(request):
    return render(request,'order/checkout_fail.html')




def orders(request):
    order_items = Order.objects.all()
    q = request.GET.get('q')
    if q:
        order_items = order_items.filter(Q(name__icontains=q)|Q(order_number__icontains=q))

    # print(order_items)
    context = {
        'order_items': order_items,
    }
    return render(request, 'order/order.html', context)


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



def my_order_detail(request):
    orders = Order.objects.filter(user=request.user)

    context ={
        'orders':orders,
    }

    return render(request,'order/my_order_details.html',context)