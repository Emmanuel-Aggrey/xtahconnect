# Generated by Django 2.2.10 on 2021-02-20 03:39

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ecommerce', '0016_auto_20210220_0336'),
    ]

    operations = [
        migrations.AddField(
            model_name='product',
            name='is_promational',
            field=models.BooleanField(default=False, null=True),
        ),
    ]