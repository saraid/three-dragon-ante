Dir.each_child(File.join(__dir__, 'card')) do |card|
  next unless card.end_with?('.rb')
  require_relative "card/#{card}"
end

module ThreeDragonAnte
  class Card
    include Refinements::Inspection
    GODS = %i( Bahamut Tiamat )
    MORTALS = %i(TheArchmage TheDragonslayer TheDruid TheFool ThePriest ThePrincess TheThief)
    UNIQUES = %i(Dracolich)

    TAGS = %i( dragon mortal good evil god undead)

    def initialize(name, tags, strength)
      @name, @strength = name, strength
      @tags = tags
    end
    attr_reader :name, :strength, :tags
    attr_writer :strength
    protected :strength=

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
      raise NotImplementedError
    end

    def build_copy(new_class, new_strength)
      if new_class.instance_method(:initialize).arity == 1 then instance = new_class.new(new_strength)
      else instance = new_class.new.tap { _1.strength = new_strength }
      end
    end
  end
end
