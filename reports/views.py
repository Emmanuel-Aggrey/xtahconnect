from django.shortcuts import render
from django.shortcuts import redirect
from django.contrib.auth.decorators import user_passes_test
from django.contrib.admin.views.decorators import staff_member_required
from django.contrib.auth.models import User
from orders.models import Order,OrderItem
from django.db.models import Sum,Count
# Create your views here.




# @user_passes_test(lambda u: u.is_staff)
# @staff_member_required
def customers_data(request):
    if not request.user.is_staff:
        return redirect('/')
    # customers = User.objects.filter(is_staff=False,is_superuser=False)
    # orders = OrderItem.objects.filter(order__user__is_staff=False,order__user__is_superuser=False).annotate(orders_made=Count('order'))

    context = {
        # 'customers':customers,
        # "orders":orders,
    }
    return render(request,'reports/customers.html',context)
    

