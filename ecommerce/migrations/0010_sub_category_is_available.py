# Generated by Django 2.2.10 on 2020-12-02 11:39

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ecommerce', '0009_auto_20201117_0616'),
    ]

    operations = [
        migrations.AddField(
            model_name='sub_category',
            name='is_available',
            field=models.BooleanField(default=False),
        ),
    ]
