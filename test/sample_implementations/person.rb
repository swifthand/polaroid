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
