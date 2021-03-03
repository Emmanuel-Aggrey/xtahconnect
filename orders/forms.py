from django import forms
from .models import Order#,City


class OrderCreateForm(forms.ModelForm):
    address = forms.CharField(required=True,widget=forms.Textarea(attrs={'placeholder':'Street Name / Building /Apartment No /Floor/ Closest Landmark'}))
    class Meta:
        model = Order
        exclude = ['user','paid','location']


    
    # def __init__(self, *args, **kwargs):
    #     super().__init__(*args, **kwargs)
    #     self.fields['city'].queryset = City.objects.none()

    #     if 'region' in self.data:
    #         try:
    #             region_id = int(self.data.get('region'))
    #             self.fields['city'].queryset = City.objects.filter(region_id=region_id).order_by('name')
    #         except (ValueError, TypeError):
    #             pass  # invalid input from the client; ignore and fallback to empty City queryset
    #     elif self.instance.pk:
    #         self.fields['city'].queryset = self.instance.region.city_set.order_by('name')

