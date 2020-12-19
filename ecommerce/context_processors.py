from .models import Category,Product,Sub_Category

def category(request):
    nav = Category.objects.filter(is_available=True)
    sub_category = Sub_Category.objects.order_by('category__date_updated').filter(is_available=True)
    popular = Product.objects.filter(is_available=True).order_by('-date_updated')

    return {'nav':nav,'popular':popular,'sub_category':sub_category}

