# Generated by Django 2.2.10 on 2021-02-24 00:16

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ecommerce', '0002_auto_20210223_2037'),
    ]

    operations = [
        migrations.RenameField(
            model_name='product',
            old_name='from_date',
            new_name='end_date',
        ),
        migrations.RenameField(
            model_name='product',
            old_name='to_date',
            new_name='start_date',
        ),
    ]