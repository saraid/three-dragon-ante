require_relative './card'

module ThreeDragonAnte
  class Deck
    def initialize
      @deck = []
      @discarded = []

     #%i[Archmage Bahamut Dracolich Dragonslayer Druid Fool Priest Princess Thief Tiamat].each { |name|
     #  @deck << Card.const_get(name).new
     #}

      [1, 2, 3, 5,  7,  9].each { |str| @deck << Card::BlackDragon.new(str)  }
      #[1, 2, 4, 7,  9, 11].each { |str| @deck << Card::BlueDragon.new(str)   }
      #[1, 2, 4, 5,  7,  9].each { |str| @deck << Card::BrassDragon.new(str)  }
      #[1, 3, 6, 7,  9, 11].each { |str| @deck << Card::BronzeDragon.new(str) }
      #[1, 3, 5, 7,  8, 10].each { |str| @deck << Card::CopperDragon.new(str) }
      #[2, 4, 6, 9, 11, 13].each { |str| @deck << Card::GoldDragon.new(str)   }
      #[1, 2, 4, 6,  8, 10].each { |str| @deck << Card::GreenDragon.new(str)  }
      #[2, 3, 5, 8, 10, 12].each { |str| @deck << Card::RedDragon.new(str)    }
      #[2, 3, 6, 8, 10, 12].each { |str| @deck << Card::SilverDragon.new(str) }
      #[1, 2, 3, 4,  6,  8].each { |str| @deck << Card::WhiteDragon.new(str)  }

      @deck.shuffle!
    end

    def draw!
      @deck.shift.tap do |card|
        @discarded << card
      end
    end

    def reshuffle!
      @deck.concat(@discarded)
      @discarded.clear
      @deck.shuffle!
    end

    def size
      @deck.size
    end

    def pull_card(rank, suite)
      @deck.find { |card| card.rank == rank && card.suite == suite }.tap do |card|
        @discarded << @deck.delete(card)
        @deck.compact!
      end
    end

    def stack!(rank, suite = [:Hearts, :Diamonds, :Clubs, :Spades].sample)
      card = pull_card(rank, suite)
      reshuffle! if card.nil?
      card ||= pull_card(rank, suite)
      @deck.unshift(card)
      :ok
    end
  end
end
