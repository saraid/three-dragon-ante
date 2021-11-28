module ThreeDragonAnte
  class Card
    include Refinements::Inspection
    GODS = %i( Bahamut Tiamat )
    MORTALS = %i(TheArchmage TheDragonslayer TheDruid TheFool ThePriest ThePrincess TheThief)
    UNIQUES = %i(Dracolich)
    EVIL_DRAGONS = %i( BlackDragon BlueDragon GreenDragon RedDragon WhiteDragon )
    GOOD_DRAGONS = %i( BronzeDragon BrassDragon CopperDragon GoldDragon SilverDragon )

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

    def dragon_god?
      dragon? && god?
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

    MANIPULATION_TARGETS = %i(flights hands ante hoards stakes turn_order gambit_outcome).each do |target|
      singleton_class.class_eval do
        define_method(:manipulation_targets) { @manipulation_targets ||= [] }
        define_method(:"manipulates_#{target}!") { manipulation_targets << target }
        define_method(:"manipulates_#{target}?") do
          manipulation_targets.include? target || manipulation_targets.include?(:everything)
        end
      end
      define_method(:"manipulates_#{target}?") { self.class.send(:"manipulates_#{target}?") }
    end

    def self.manipulates_everything!
      @manipulation_targets = MANIPULATION_TARGETS
    end

    def manipulates_cards?
      manipulates_hands? || manipulates_ante? || manipulates_flights? || manipulates_everything?
    end

    def manipulates_gold?
      manipulates_hoards? || manipulates_stakes? || manipulates_everything?
    end

    def manipulation_targets
      self.class.manipulation_targets
    end
  end
end

Dir.each_child(File.join(__dir__, 'card')) do |card|
  next unless card.end_with?('.rb')
  require_relative "card/#{card}"
end
