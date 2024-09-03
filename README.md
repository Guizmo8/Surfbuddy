Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.

### Code to create a message from twilio

```
client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TOKEN'])

client.messages.create(
  from: Alert::PHONE_NUMBER,
  to: to, # Replace with the user phone number
  body: "Hey friend!"  # Content of the sms sent = alerts
)
```
