from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_POST
from ecommerce.models import Product
from .cart import Cart
from .forms import CartAddProductForm
from  django.http import  HttpResponse,JsonResponse


@require_POST
def cart_add(request,product_id):
    cart = Cart(request)  # create a new cart object passing it the request object 
    product = get_object_or_404(Product, id=product_id) 
    form = CartAddProductForm(request.POST)
    if form.is_valid():
        cd = form.cleaned_data
        cart.add(product=product, quantity=cd['quantity'], update_quantity=cd['update'])
        # print("cart_total",len(cart))
    # return HttpResponse()
    return redirect('cart:cart_detail')

def cart_remove(request, product_id):
    cart = Cart(request)
    product = get_object_or_404(Product, id=product_id)
    cart.remove(product)
    return redirect('cart:cart_detail')


def cart_detail(request):
    cart = Cart(request)
    for item in cart:
        item['update_quantity_form'] = CartAddProductForm(initial={'quantity': item['quantity'], 'update': True})
    return render(request,'cart/cart_detail.html', {'cart': cart})


def cart_size(request):
    cart = Cart(request)
    return JsonResponse({'size': len(cart)})