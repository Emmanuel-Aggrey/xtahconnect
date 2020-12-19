from django import forms
from .models import Product,Sub_Category
from ckeditor.widgets import CKEditorWidget

class ProductForm(forms.ModelForm):
    description = forms.CharField(widget=CKEditorWidget())

    class Meta:
        model = Product
        exclude = ['category']

        