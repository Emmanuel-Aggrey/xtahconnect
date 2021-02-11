from django.urls import path
from . import views

urlpatterns=[
    path("",views.index,name="index"),
    path("about/",views.aboutpage, name="about"),
    path('detail/<slug:slug>/',views.product_datilview, name='product-detail'),
    path('category/<int:id>/',views.category_view,name='categories'),
    path("register/",views.register,name="register"),
    # path("login/",views.login,name="login"),
    # path("logout/",views.logout,name="logout"),


    # createview
    path("create/",views.CategoryView.as_view(), name="create_form"),
    path("create_subcategory/<int:id>/",views.create_subcategory, name="create_subcategory"),
    path("add/product/<int:id>/",views.producCreatetView, name="add_product"),

    path("search/",views.search,name="search"),
    path("search_api/",views.search_api,name='search_api'),
]