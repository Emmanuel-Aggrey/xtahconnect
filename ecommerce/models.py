from ckeditor.fields import RichTextField
from django.db import models
from django.db.models.signals import post_save, pre_save
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
    name = models.CharField('sub category', max_length=800, unique=True)
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
    name = models.TextField()
    quantity = models.IntegerField(default=1, blank=True)
    image = models.ImageField(upload_to='images/%Y/%m/%d/')
    price = models.DecimalField(
        'original price', decimal_places=2, max_digits=20)
    discount = models.PositiveIntegerField(
        'discount %', null=True, blank=True, default=0, help_text='enter percentage value eg 5 not 5%')
    description = RichTextField(blank=True, null=True)
    is_available = models.BooleanField(default=True)
    slug = models.SlugField(unique=True, editable=False,
                            null=True, blank=True, max_length=1000)
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
    video1 = models.FileField(
        upload_to='videos/%Y/%m/%d/', null=True, blank=True)
    video2 = models.FileField(
        upload_to='videos/%Y/%m/%d/', null=True, blank=True)
    video3 = models.FileField(
        upload_to='videos/%Y/%m/%d/', null=True, blank=True)

    # promational products
    text = models.TextField(null=True, blank=True)
    discount_price = models.PositiveIntegerField(
        'price', blank=True, null=True)
    start_date = models.DateTimeField(
        blank=True, null=True, default=timezone.now)
    end_date = models.DateTimeField(
        blank=True, null=True, default=timezone.now)
    is_promational = models.BooleanField('promotion', default=False)

    # create a new slug

    # def save(self, *args, **kwargs):
    #     if not self.slug:
    #         self.slug = slugify(self.name)
    #     return super().save(*args, **kwargs)

    def get_absolute_url(self):
        return reverse("product-detail", kwargs={"slug": self.slug})

    def __str__(self):
        return f'{self.name}: {self.category}'

    @property
    def promotional_products(self):
        return Product.objects.filter(is_promational=True, date_updated__range=[self.start_date, self.end_date])



    @property
    def discount_price(self):
        if self.discount:
            discount = (self.price * self.discount)/100
            # to 2 decimal places
            return discount
        else:
            return 'no discount'

    @property
    def percentageoff(self):
        if self.discount:
            discount = (self.price * self.discount)/100
            discount =self.price - discount
            # to 2 decimal places
            return '{0:.2f}'.format(discount)
        else:
            return self.price


# create slug from product name
@receiver(post_save, sender=Product)
def post_save_handler(sender, instance, created, *args, **kwargs):
    if created:
        slug = slugify(instance.name)
        instance.slug = slug+'-'+str(instance.id)
        instance.save()


class Reminder(Base_Model):
    stock_size = models.PositiveIntegerField(
        help_text='enter the quantity to truck out of stock items', blank=True, null=True)

    def __str__(self):
        return f'{self.stock_size}'


class Launching(models.Model):
    name = models.CharField(max_length=500, blank=True, null=True)
    image = models.ImageField()
    description = RichTextField(blank=True, null=True)
    in_progress = models.BooleanField(default=True)

    def __str__(self):
        return f'{self.name} {self.in_progress}'

    class Meta:
        # managed = True
        verbose_name = 'Launching'
        verbose_name_plural = 'Launching'
