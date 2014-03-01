# Polaroid

Polaroid provides shortcuts to capture the state of a Ruby object, and can construct a fake object later to mimic that state.

## Why?

Never send a Hash to do an Object's job. Method dispatch is faster and method calls look cleaner than nested\['braces'\]\['everywhere'\] in your code.

## But why would you ever need that?

The use case that inspired Polaroid involved using a background worker to send an Email. The email was being templated from a single View-Model object. Rather than shuffling database primary keys across a queue (be it Redis, or a real messaging system like Rabbit) and bothering the database later, we can just build the View-Model now, capture its state as JSON, and send that off to the Mailer.

But that requires the templates now access data from a Hash. And you should never send a Hash to do an Object's job.

Well, since we were already pulling these values from an object, why not just push them back into a Fake that shares the same interface of the View-Model? Or at least as much interface as we care about.

It takes all sorts of bul

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/swifthand/polaroid/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

