Dir.each_child(File.join(__dir__, 'card')) do |card|
  next unless card.end_with?('.rb')
  require_relative "card/#{card}"
end

module ThreeDragonAnte
  class Card
    include Refinements::Inspection
    TAGS = %i( dragon mortal good evil god undead)

    def initialize(name, tags, strength)
      @name, @strength = name, strength
      @tags = tags
    end
    attr_reader :name, :strength, :tags

    TAGS.each do |tag|
      define_method(:"#{tag}?") { @tags.include? tag }
    end

    def good_dragon?
      good? && dragon?
    end

    def evil_dragon?
      evil? && dragon?
    end

    def inspectable_attributes
      %i( strength tags )
    end

    def trigger_power!(gambit, player)
      #raise NotImplementedError
    end
  end
end
