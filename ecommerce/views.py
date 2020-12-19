from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth.models import User, auth
from django.db.models import Q
from django.shortcuts import get_object_or_404, redirect, render
from django.urls import reverse_lazy
from django.views.generic import DetailView, ListView, TemplateView
from django.views.generic.edit import CreateView, DeleteView, UpdateView
from django.template.defaultfilters import  slugify

from .models import Category, Product, Sub_Category
from hashids import Hashids

from .forms import ProductForm
# Create your views here.
hashids = Hashids()


def index(request):
    products = Product.objects.filter(is_available=True)

        # print(request.session['history'])
    resent_view_products = ''
    if request.session.get('history',None):
        resent_view_products = Product.objects.filter(slug__in=(request.session['history']))[:8]

  
  
    
    context = {
        'products': products,
        'resent_view_products':resent_view_products,
    }
    return render(request, 'index.html', context)

# return render(request,'index.html',context)


def product_datilview(request, slug):
    # request.session.setdefault('history',[]).append(slug)
    product = get_object_or_404(Product, slug=slug)

  


    request.session.setdefault('history',[])
    if slug in request.session['history']:
        request.session.modified = False
    else:
        request.session.setdefault('history',[]).append(slug)
        request.session.modified = True
    
  
    print(request.session['history'])


    context ={
        'product':product
    }
    return render(request,'product_detail.html',context)
    

def category_view(request,id):
    
    allrelated = Sub_Category.objects.get(id=id)

    products = allrelated.products.filter(is_available=True)
    resent_view_products = ''
    if request.session.get('history',None):
        resent_view_products = Product.objects.filter(slug__in=(request.session['history']))[:8]


    # print(products)

    context ={
        'products':products,
        'allrelated':allrelated,
        'resent_view_products':resent_view_products,

    }
    return render(request,'categories.html',context)


def register(request):
    if request.method=='POST':
        first_name=request.POST['first_name']
        last_name=request.POST['last_name']
        username=request.POST['username']
        email=request.POST['email']
        password1=request.POST['password1']
        password2=request.POST['password2']
        if password1==password2:
            if(User.objects.filter(username=username).exists()):
                messages.warning(request,"User Name Already Exists")
                return redirect('register')
            elif(User.objects.filter(email=email).exists()):
                messages.warning(request,"Email Already Exists")
                return redirect('register')
            else:
                user=User.objects.create_user(
                    password=password1,  
                    username=username, 
                    first_name=first_name, 
                    last_name=last_name, 
                    email=email,
                )
                user.save()
                messages.success(request,"User Created")
                return redirect('register')
        else:
            messages.warning(request,"User Password MisMatching")
            return redirect('register')

    else:
        return render(request,'checkout-shipping.html')
def login(request):
    username=request.POST.get('username')
    password=request.POST.get('password')
    if request.method=="POST":
        user=auth.authenticate(username=username,password=password)
        if user is not None:
            auth.login(request,user)
            return redirect('/')
        else:
            messages.warning(request,"Invalid Credentials")
            return redirect('login')
    else:
        return render(request,"checkout-shipping.html")
def logout(request):
    auth.logout(request)
    return redirect("/")



# forms
class CategoryView(LoginRequiredMixin,CreateView,ListView):
    model = Category
    # queryset = Category.objects.all()
    context_object_name = 'categories'
    fields = ['name']
    template_name ='category_form.html'
    success_url = reverse_lazy('create_form')

   

def create_subcategory(request,id):
    name = request.POST.get('name')

    print('name',name,'id',id)

    Sub_Category.objects.bulk_create([
        Sub_Category(name=name,category_id=id)
    ])
    messages.info(request,'item saved')
    return redirect('create_form')




def search(request):
    products = Product.objects.filter(is_available=True)

 
    q = request.GET.get('q')
    if q:
        # print(q)
        products = products.filter(Q(name__icontains=q)|Q(category__name__icontains=q))

        # print(products)
    context = {
        'products': products,
    }

    return render(request,'search.html',context)



def producCreatetView(request,id):
    product = get_object_or_404(Sub_Category,id=id)
    form = ProductForm(request.POST or None,request.FILES)
    
    if form.is_valid():
        name = form.cleaned_data['name']
        price = form.cleaned_data['price']
        image = form.cleaned_data['image']
        description = form.cleaned_data['description']
        slug  = slugify(name)



        id_ = Product.objects.values_list('pk', flat=True).count()
        id_ = str(hashids.encode(id_))
     
        slug =  slug+'-'+id_


        Product.objects.bulk_create([
        Product(name=name,price=price,description=description,image=image,category_id=id,slug=slug)
        ])

        messages.info(request,'item saved')

        return redirect('add_product',id)
    
    context = {
        'product':product,
        'form':form,
    }
    return render(request,'add_product.html',context)


def aboutpage(request):
    return render(request,'about.html')

def error404(request, exception):
    context = {
        'date': 'IT LOOKS LIKE YOU\'R MISSING',
    }
    return render(request, 'error_pages/error404.html', context)


def error500(request):

    return render(request, 'error_pages/error500.html')
