require 'test_helper'
require 'sample_implementations/person'

class PolaroidTest < Minitest::Test


  test "simple hash snapshot" do
    pat       = Person.new("Patrick", 25, ['beer', 'coffee', 'ramen', 'pie'])
    expected  = { name: "Patrick", age: 25, favorite_drinks:  ['beer', 'coffee'] }

    assert_equal(expected, pat.take_snapshot)
  end


  test "can restore from a snapshot" do
    snapshot  = { name: "Patrick", age: 25, favorite_drinks:  ['beer', 'coffee'] }
    pat       = Person.build_from_snapshot(snapshot)

    assert_equal("Patrick", pat.name)
    assert_equal(25, pat.age)
    assert_equal(['beer', 'coffee'], pat.favorite_drinks)
  end


  test "objects restored from snapshot do not respond to messages not captured" do
    snapshot  = { name: "Patrick", age: 25, favorite_drinks:  ['beer', 'coffee'] }
    pat       = Person.build_from_snapshot(snapshot)
    will_respond_to = [:name, :age, :favorite_drinks]
    wont_respond_to = [:favorite_foods, :drink?, :food?, :favorites]

    will_respond_to.each do |msg|
      assert(pat.respond_to?(msg))
    end
    wont_respond_to.each do |msg|
      refute(pat.respond_to?(msg))
    end
  end

  ##
  # Testing the string-equality of direct JSON output is not the optimal manner of
  # testing the output of this, as it would bind this check to the specific output
  # format of a particular JSON library's internal choices on formatting, whereas
  # JSON is flexible to some amount of whitespace.
  test "json snapshot parses back to the correct value" do
    pat       = Person.new("Patrick", 25, ['beer', 'coffee', 'ramen', 'pie'])
    snapshot  = pat.take_snapshot(:json)
    # JSON will come back with string keys, not symbols
    expected  = { 'name' => "Patrick", 'age' => 25, 'favorite_drinks' =>  ['beer', 'coffee'] }
    parsed    = JSON.parse(snapshot)

    assert_equal(expected, parsed)
  end


  test "objects can be restored from a json snapshot" do
    snapshot  = "{\"name\":\"Patrick\",\"age\":25,\"favorite_drinks\":[\"beer\",\"coffee\"]}"
    pat       = Person.build_from_snapshot(snapshot, :json)

    assert_equal("Patrick", pat.name)
    assert_equal(25, pat.age)
    assert_equal(['beer', 'coffee'], pat.favorite_drinks)
  end

end
