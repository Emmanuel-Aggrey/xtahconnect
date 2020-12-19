# Generated by Django 2.2.10 on 2020-09-22 22:20

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('orders', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='order',
            options={'ordering': ('-date_updated',)},
        ),
        migrations.RenameField(
            model_name='order',
            old_name='updated',
            new_name='date_add',
        ),
        migrations.RenameField(
            model_name='order',
            old_name='created',
            new_name='date_updated',
        ),
        migrations.AddField(
            model_name='orderitem',
            name='date_add',
            field=models.DateTimeField(auto_now=True),
        ),
        migrations.AddField(
            model_name='orderitem',
            name='date_updated',
            field=models.DateTimeField(auto_now_add=True, default=django.utils.timezone.now),
            preserve_default=False,
        ),
    ]
