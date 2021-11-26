Dir.each_child(File.join(__dir__, 'card')) do |card|
  require_relative "card/#{card}"
end

module ThreeDragonAnte
  class Card
    TAGS = %i( dragon mortal good evil god undead)

    def initialize(name, tags, strength)
      @name, @strength = name, strength
      @tags = tags
    end
    attr_reader :name, :strength

    TAGS.each do |tag|
      define_method(:"#{tag}?") { @tags.include? tag }
    end
  end
end
