from django import forms
from orders.models import Order


class DeleveryStatusForm(forms.ModelForm):

    class Meta:

        model = Order
        fields = ['delevery_Status',]