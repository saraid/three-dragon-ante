module Factory
  def self.ante_to_choose_leader(identifier_or_index, player_count: 3)
    index =
      case identifier_or_index
      when Symbol then PLAYER_IDENTIFIERS.index(identifier_or_index)
      when Integer then identifier_or_index
      end

    stacked_ante = player_count.times.map { { strength: proc { _1 < 13 } } }
    stacked_ante[index] = { strength: proc { _1 == 13 } }
    stacked_ante
  end

  def self.flights(player_order: PLAYER_IDENTIFIERS[0...3], flights:)
    flights.values.each do |flight|
      (ThreeDragonAnte::Game::Player::STARTING_HAND_SIZE - flight.size).times { flight << {} }
    end
    head_flight, *rest_flights = flights.values_at(*player_order)
    head_flight.zip(*rest_flights).flatten.compact
  end
end
