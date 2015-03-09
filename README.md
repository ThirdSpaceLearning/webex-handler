# Webex::Handler

A gem to handle interactions with Cisco's WebEx voice conferencing solution.

With it you can create and destroy sessions, as well as download and delete the session recordings to an alternate server. The latter is especially useful, given the costs of remote hosting.

Currently, all user accounts need to be created through the web interface.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'webex-handler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install webex-handler

## Usage

Prepare your config/settings.yml file with the fields:

```
webex_site_name: "[your data here]"
webex_site_id: "[your data here]"
webex_partner_id: "[your data here]"
```

These can be found from your webex control panel.

```
@response = Webex::Handler::Session.create!(webex_attributes)
```

Where the attributes are created with a line such as:

```
 webex_attributes = {
    username: '[username]', 
    password: '[password]', 
    email: '[email]', 
    topic_name: '[topic name]',
    agenda: '[agenda]',
    attendee: '[attendee name]',
    duration: '[time in minutes]', 
    session_date_time: "#{time.strftime('%m/%d/%Y')} #{(time.in_time_zone('London')}"
  }
```
              
For most operations, you will need the username and password of the user that is going to be hosting the meeting. With this you can then delete the session.

```
Webex::Handler::Session.destroy(username: '[username]', password: '[password]', key: '[session key]')
```

See the handler classes for full details.

It is up to you to store the session key, and other assorted data, in your DB.



## Contributing

1. Fork it ( https://github.com/ThirdSpaceLearning/webex-handler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


# About Third Space Learning

TSL provide one-to-one Maths intervention directly into schools. We use technology to achieve this, working with academic talent at a global level to deliver scalable, affordable, expert one-to-one online support to students in schools across the UK.

To do this we build technology to make it as simple as possible for every child to access specialist support to delight and inspire their learning.


As a company it is formally known as 'Virtual Class Ltd', but no one uses that. Third Space, will do, thanks!
