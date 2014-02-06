#Welcome to Handraise!

HandRaise is a 'question counter' for creating question queues in a class setting. It allows the teacher or TA to see who to help next.

##Versions / Database
* Ruby 1.9.3
* Rails 3.2
* Postgres database

##Getting Started: Application.yml file
* Create an application.yml file
* Insert the following code into the application.yml, replacing [[input_description]] with the actual input:
TWILIO_ACCOUNT_SID: [[Twilio account SID]]
TWILIO_AUTH_TOKEN: [[Twilio account auth token]]
TWILIO_FROM: [[Twilio phone number]]

GITHUB_CLIENT_ID: [[Github client_ID]]
GITHUB_CLIENT_SECRET: [[Github client_secret]]

MAILGUN_DOMAIN   : [[Mailgun domain name]]
MAILGUN_LOGIN    : [[Mailgun user name]]
MAILGUN_PASSWORD : [[Mailgun password]]

## Getting Started: Part 2
* bundle install
* rake db:create
* rake db:migrate
* Update exception notification email details in exception_notifier.rb

## Web Servers & background processes
* rails s
* http://localhost:3000/
* whenever --update-crontab

## About us
Handrai.se was built by "Anthony Wijnen":https://github.com/awijnen , "Ei-Lene Heng":https://github.com/eewang ,  "Eugene Wang":https://github.com/eewang and "Jane Vora":https://github.com/janeeats while attending "The Flatiron School":http://flatironschool.com/

last update: 26th April 2013

