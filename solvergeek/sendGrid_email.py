
import os
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from decouple import config
# import requests


# def send_simple_message():
#     return requests.post(
#         "https://api.mailgun.net/v3/xtayconnectafrica.com/messages",
#         auth=("api", "MAILGUN API"),
#         data={"from": "noreplysefs@xtayconnectafrica.com",
#               "to": ["teye.etn@gmail.com", "aggrey.en@gmail.com", 'aggrey.en@live.com'],
#               "subject": "Hello Aggrey",
#               "text": "Testing some Mailgun awesomness! Please work"})


# send_simple_message()


# message = Mail(
#     from_email='orders@xtayconnectafrica.com',
#     to_emails='aggrey.en@gmail.com',
#     subject='Sending with Twilio SendGrid is Fun',
#     html_content='<strong>and easy to do anywhere, even with Python <a href="xtayconnectafrica.com">view here now Aggrey</a></strong>')
# try:
#     sg = SendGridAPIClient(config('SENDGRID_API_KEY'))
#     response = sg.send(message)
#     print(response.status_code)
#     print(response.body)
#     print(response.headers)
# except Exception as e:
#     print(e.message)


def send_sendGredemail(to_emails, subject, html_content,from_email='orders@xtayconnectafrica.com'):


    message = Mail(
    from_email=from_email,
    to_emails=to_emails,
    subject=subject,
    html_content=html_content

    )


    try:
        sg = SendGridAPIClient(config('SENDGRID_API_KEY'))
        response = sg.send(message)
        print(response.status_code)
        print(response.body)
        print(response.headers)
    except Exception as e:
        print(e.message)
