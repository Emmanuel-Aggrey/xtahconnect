# Generated by Django 2.2.10 on 2021-02-20 04:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ecommerce', '0020_auto_20210220_0435'),
    ]

    operations = [
        migrations.AlterField(
            model_name='product',
            name='is_promational',
            field=models.BooleanField(default=False, editable=False),
        ),
    ]
