require_relative './card'

module ThreeDragonAnte
  class Deck
    include Refinements::Inspection

    def initialize
      @deck = []
      @discarded = []

     (Card::GODS + Card::MORTALS + Card::UNIQUES).each { |name|
       @deck << Card.const_get(name).new if Card.constants.include? name
     }

      [1, 2, 3, 5,  7,  9].each { |str| @deck << Card::BlackDragon.new(str)  }
      [1, 2, 4, 7,  9, 11].each { |str| @deck << Card::BlueDragon.new(str)   }
      [1, 2, 4, 5,  7,  9].each { |str| @deck << Card::BrassDragon.new(str)  }
      [1, 3, 6, 7,  9, 11].each { |str| @deck << Card::BronzeDragon.new(str) }
      [1, 3, 5, 7,  8, 10].each { |str| @deck << Card::CopperDragon.new(str) }
      [2, 4, 6, 9, 11, 13].each { |str| @deck << Card::GoldDragon.new(str)   }
      [1, 2, 4, 6,  8, 10].each { |str| @deck << Card::GreenDragon.new(str)  }
      [2, 3, 5, 8, 10, 12].each { |str| @deck << Card::RedDragon.new(str)    }
      [2, 3, 6, 8, 10, 12].each { |str| @deck << Card::SilverDragon.new(str) }
      [1, 2, 3, 4,  6,  8].each { |str| @deck << Card::WhiteDragon.new(str)  }

      @deck.shuffle!
    end

    def custom_inspection
      " #{size} cards (#{@discarded.size} discarded)"
    end

    def draw!
      @deck.shift
    end

    def discarded(card)
      @discarded << card
    end

    def reshuffle!
      @deck.concat(@discarded)
      @discarded.clear
      @deck.shuffle!
    end

    def size
      @deck.size
    end

    def peek(num)
      @deck[0...num]
    end

    def pull_card(type: nil, strength: nil, tags: [], is_not: [])
      not_types, not_tags = is_not.group_by(&:class).values_at(Class, Symbol)

      conditions = []
      conditions << proc { type === _1 } unless type.nil?
      conditions << proc { |card| tags.all? { |tag| card.tags.include?(tag) } } unless tags.empty?
      conditions <<
        case strength
        when Integer then proc { _1.strength == strength }
        when Proc then proc { _1.strength } >> strength
        else nil
        end
      conditions << proc { |card| !not_types.any? { |klass| klass === card } } unless not_types.nil?
      conditions << proc { |card| !not_tags.all? { |tag| card.tags.include?(tag) } } unless not_tags.nil?
      conditions.compact!

      @deck.find { |card| conditions.all? { |condition| condition.call(card) }}.tap do |card|
        raise 'Could not find card' if card.nil?
        puts "pulled #{card.inspect}"
        @deck.delete(card)
      end
    end

    def stack!(type: nil, strength: nil, tags: [])
      card = pull_card(type: type, strength: strength, tags: tags)
      reshuffle! if card.nil?
      card ||= pull_card(type: type, strength: strength, tags: tags)
      @deck.unshift(card)
      :ok
    end

    def stack_set!(set)
      reshuffle!
      set
        .reverse
        .map { |conditions| pull_card(**conditions) }
        .each { |card| @deck.unshift(card) }
      :ok
    end
  end
end
