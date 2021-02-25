from ckeditor.fields import RichTextField
from django.db import models
from django.db.models.signals import post_save,pre_save
from django.dispatch import receiver
from django.shortcuts import reverse
from django.template.defaultfilters import slugify
from django.utils import timezone
from hashids import Hashids

# Create your models here.
hashids = Hashids()


class Base_Model(models.Model):
    date_add = models.DateTimeField(auto_now=True)
    date_updated = models.DateTimeField(auto_now_add=True)

    class Meta:
        abstract = True


class Category(Base_Model):
    name = models.CharField(max_length=800, unique=True)
    is_available = models.BooleanField(default=True)


    def get_absolute_url(self):
        return reverse("category_page")


    class Meta:
        verbose_name = "Category"
        verbose_name_plural = "Categories"


    def __str__(self):
        return self.name

    



class Sub_Category(Base_Model):
    category = models.ForeignKey(
        Category, on_delete=models.CASCADE, related_name='sub_categories')
    name = models.CharField('sub category', max_length=800)
    is_available = models.BooleanField(default=True)

    # create a new slug
    # def save(self, *args, **kwargs):
    #     if not self.slug:
    #         self.slug = slugify(self.name)
    #     return super().save(*args, **kwargs)

    def __str__(self):
        return f'{self.category} : {self.name}'

    class Meta:
        verbose_name = 'Sub Category'
        verbose_name_plural = 'Sub Categories'


class Product(Base_Model):
    category = models.ForeignKey(
        Sub_Category, on_delete=models.CASCADE, related_name='products')
    name = models.CharField(max_length=800)
    image = models.FileField(upload_to='images/%Y/%m/%d/')
    price = models.DecimalField(decimal_places=2, max_digits=20)
    discount = models.PositiveIntegerField('discount price',null=True,blank=True,default=0)
    description = RichTextField(blank=True, null=True)
    is_available = models.BooleanField(default=True)
    slug = models.SlugField(unique=True, editable=False, null=True, blank=True)
    image1 = models.ImageField(
        upload_to='images/%Y/%m/%d/', null=True, blank=True)
    image2 = models.ImageField(
        upload_to='images/%Y/%m/%d/', null=True, blank=True)
    image3 = models.ImageField(
        upload_to='images/%Y/%m/%d/', null=True, blank=True)
    image4 = models.ImageField(
        upload_to='images/%Y/%m/%d/', null=True, blank=True)
    image5 = models.ImageField(
        upload_to='images/%Y/%m/%d/', null=True, blank=True)


    # promational products
    text = models.CharField(max_length=30,blank=True, null=True)
    discount_price = models.PositiveIntegerField(blank=True,null=True)
    start_date = models.DateTimeField(blank=True, null=True)
    end_date = models.DateTimeField(blank=True, null=True)
    is_promational = models.BooleanField(default=False,editable=False)

    # create a new slug

    # def save(self, *args, **kwargs):
    #     if not self.slug:
    #         self.slug = slugify(self.name)
    #     return super().save(*args, **kwargs)

    def get_absolute_url(self):
        return reverse("product-detail", kwargs={"slug": self.slug})

    def __str__(self):
        return f'{self.name}: {self.category}'

    def promotional_products(self):
        return  Product.objects.filter(is_promational=True,date_updated__range=[self.start_date,self.end_date])

    # def save(self, *args, **kwargs):
    #     id_ = Product.objects.values_list('pk', flat=True).count()
    #     id_ = str(id_)
    #     slug = slugify(self.name)
    #     self.slug = slug+'-'+id_
    #     return super().save(*args, **kwargs)

    @property
    def percentageoff(self):
        if self.discount:
            return  round(self.discount / self.price * 100, 2)
    
            # mydis = int(dis)
            
        

@receiver(pre_save,sender=Product)
def pre_saved_handler(sender,instance,*args, **kwargs):
    if instance.text:
        instance.is_promational =True
    else:
        instance.is_promational= False
        instance.discount_price=None
        instance.start_date =None
        instance.end_date =None

@receiver(post_save,sender=Product)
def post_save_handler(sender,instance,created,*args, **kwargs):
    if created:
        slug = slugify(instance.name)
        instance.slug = slug+'-'+str(instance.id)
        instance.save()



# thethella
# skype id : asare_stephen111
# https://theteller.net/documentation
