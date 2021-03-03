from django.shortcuts import render
from django.shortcuts import redirect
from django.contrib.auth.decorators import user_passes_test
from django.contrib.admin.views.decorators import staff_member_required
from django.contrib.auth.models import User
from orders.models import Order, OrderItem
from ecommerce.models import Sub_Category, Product
from django.contrib.auth.decorators import login_required

from django.db.models import Sum, Count,Max
# Create your views here.


# @user_passes_test(lambda u: u.is_staff)
# @staff_member_required
def customers_data(request):
    if not request.user.is_staff:
        return redirect('/')
    # customers = User.objects.filter(is_staff=False,is_superuser=False)
    orders = Order.objects.values('user__username', 'user__email', 'user__id', 'user__date_joined', 'user__last_login').filter(user__is_staff=False, user__is_superuser=False)\
        .annotate(orders_total=Count('order_number', distinct=True), purchase=Count('items', distinct=True)).order_by('user__username')

    q1 = request.GET.get('q1')
    q2 = request.GET.get('q2')
    if q1 or q2:

        orders = orders.filter(date_updated__date__range=[q1, q2]).order_by('-order_number')\
         .annotate(orders_total=Count('order_number', distinct=True), purchase=Count('items', distinct=True)).order_by('user__username')

        # print(orders.query)

    context = {
        # 'customers':customers,
        "orders": orders,

    }
    return render(request, 'reports/customers.html', context)


@login_required
def customers_order_detail(request, id):
    orders = Order.objects.filter(user__id=id)

    order_size = orders.aggregate(orders_size=Count('items'))

    print(order_size)
    context = {
        'orders': orders,
        'user': User.objects.get(id=id),
        'order_size': order_size,
    }

    return render(request, 'reports/customer_orders.html', context)

def product_report(request):
    mostly_bought_products = Sub_Category.objects.values('name')\
        .annotate(quantity_available=Sum('products__quantity'))#,quantity_bought=Sum('products__order_items__quantity'))
    
    # print(mostly_bought_products.query)
    quantity_sold_products = Sub_Category.objects.values('name')\
        .annotate(quantity_bought=Sum('products__order_items__quantity'))
    
    out_of_stock = Product.objects.filter(quantity__lte=20).values('category__name','quantity','name').order_by('-quantity')
          
    context = {
        'mostly_bought_products':mostly_bought_products,
        'quantity_sold_products':quantity_sold_products,
        "out_of_stock":out_of_stock,
     }
    return render(request,'reports/products_report.html',context)



def products_report_detail(request,name):
    Product_available = Product.objects.filter(category__name=name)

    context ={
        "Product_available":Product_available,
        'name':name,
    }

    return render(request, 'reports/product_report_detail.html',context)


def products_remaiaining_detail(request,name):
    Product_sold_out = OrderItem.objects.filter(product__category__name=name).order_by('-date_updated','-quantity')

    q1 = request.GET.get('q1')
    q2 = request.GET.get('q2')
    if q1 or q2:
        Product_sold_out = Product_sold_out.filter(date_updated__date__range=[q1, q2])

    Product_sold_out_summary = Product_sold_out.values('product__name').annotate(total_quantity=Sum('quantity')).order_by('product__name')
    # print(Product_sold_out_summary.query)


    context ={
        "Product_sold_out":Product_sold_out,
        'name':name,
        "sold_size":Product_sold_out.count(),
        'Product_sold_out_summary':Product_sold_out_summary,
        'Product_sold_out_summary_size': Product_sold_out_summary.aggregate(orders_size=Sum('total_quantity')),

    }

    return render(request, 'reports/products_remaiaining_detail.html',context)