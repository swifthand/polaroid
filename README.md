# Polaroid

Polaroid provides shortcuts to capture the state of a Ruby object, and can construct a fake object later to mimic that state.

## Why?

Never send a Hash to do an Object's job. Method dispatch is faster and method calls look cleaner than nested\['braces'\]\['everywhere'\] in your code.

## But why would you ever need that?

The use case that inspired Polaroid involved using a background worker to send an Email. The email was being templated from a single View-Model object. Rather than shuffling database primary keys across a queue (be it Redis, or a real messaging system like Rabbit) and bothering the database later, we can just build the View-Model now, capture its state as JSON, and send that off to the Mailer.

But that requires the templates now access data from a Hash. And you should never send a Hash to do an Object's job.

Well, since we were already pulling these values from an object, why not just push them back into a Fake that shares the same interface of the View-Model? Or at least as much interface as we care about.

This is just one use case I have found.

## Simple Example

In a class of which you would like to have a Snapshot, include a new instance of Polaroid, passing it the list of messages you would like to capture. These are not limited to attributes, but can be any message name. It is highly encouraged that the chosen messages be idempotent and side-effect-free wherever possible.

An example of a Person class with two attributes, and a method which selects

```ruby
class Person
  include Polaroid.new(:name, :age, :favorite_drinks)

  attr_reader :name, :age, :favorites

  def initialize(name, age, favorites)
    @name       = name
    @age        = age
    @favorites  = favorites
  end

  def favorite_drinks
    favorites.select { |fav| drink?(fav) }
  end

  def favorite_foods
    favorites.select { |fav| food?(fav) }
  end

  def drink?(str)
    %w[coffee beer wine tea water juice].include?(str)
  end

  def food?(str)
    %w[omelete burrito ramen pie yogurt].include?(str)
  end
end
```

And if we make a `Person` instance, we can take a snapshot, which by default is just a `Hash`.

```ruby
pat = Person.new('Patrick', 25, ['beer', 'coffee', 'ramen', 'pie'])
# => #<Person @name="Patrick", @age=25, @favorites=["beer", "coffee", "ramen", "pie"]>
pat.age
# => 25
pat.favorite_drinks
# => ["beer", "coffee"]
pat.favorite_foods
# => ["ramen", "pie"]
snapshot = pat.take_shapshot
# => { name: "Patrick", age: 25, favorite_drinks: ["beer", "coffee"] }
```

But now we can take that snapshot Hash and build a fake Person (actual class is `Person::Snapshot`) that responds to all the messages we chose to record from the original `Person`:

```ruby
fake_pat = Person.build_from_snapshot(snapshot)
# => #<struct Person::Snapshot name="Patrick", age=25, favorite_drinks=["beer", "coffee"]>
fake_pat.age
# => 25
fake_pat.favorite_drinks
# => ["beer", "coffee"]
```

However, since we did not record the whole `favorites` array, nor did we ask the message `favorite_foods` be included our snapshot, the `Person::Snapshot` does not respond to `favorite_foods`:

```ruby
fake_pat.favorite_foods
# => NoMethodError: undefined method `favorite_foods' for #<Person::Snapshot>
```

## Hashes? But I want JSON!

Of course you do. So the `take_snapshot` and `build_from_snapshot` methods also take a trailing `format` parameter:

```ruby
pat = Person.new('Patrick', 25, ['beer', 'coffee', 'ramen', 'pie'])
json_snapshot = snapshot.take_snapshot(pat, :json)
# => "{\"name\":\"Patrick\",\"age\":25,\"favorite_drinks\":[\"beer\",\"coffee\"]}"
Person.build_from_snapshot(json_snapshot, :json)
# => #<struct Person::Snapshot name="Patrick", age=25, favorite_drinks=["beer", "coffee"]>
```

Right now the only accepted formats are `:hash` and `:json`. If there are other serialization formats that people care about, I would be happy to have them included.


## Contributing

1. Fork it ( http://github.com/swifthand/polaroid/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

