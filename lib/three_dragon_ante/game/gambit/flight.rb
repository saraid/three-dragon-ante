module ThreeDragonAnte
  class Game
    class Gambit
      class Flight < Evented::SetOfCards
        def check_special_flight_completion!(gambit, player)
          @special_completed ||= { color: [], strength: [] }
          if color = (color_flights.keys - @special_completed[:color]).first
            game << Event::SpecialFlightCompleted[player, :color_flight, color_flights[color]]
            @special_completed[:color] = true
            gambit.players.except(player).each do |opponent|
              cash = color_flights[color][1].strength
              player.hoard.gain opponent.hoard.lose(cash, to: player)
            end
          end
          if strength_value = (strength_flights.keys - @special_completed[:strength]).first
            game << Event::SpecialFlightCompleted[player, :strength_flight, strength_flights[strength_value]]
            @special_completed[:strength] = true
            player.hoard.gain(gambit.stakes.lose(strength_value))
            2.times do
              break if player.hand.size >= Game::Player::MAX_HAND_SIZE
              player.choose_one(*gambit.ante) do |choice|
                player.hand << (gambit.ante >> choice)
              end
            end
          end
        end

        def color_flights
          @values.select(&:dragon?).group_by(&:class).select { _2.size == 3 }
        end

        def strength_flights
          @values.select(&:dragon?).group_by(&:strength).select { _2.size == 3 }
        end

        def has_dragon_god?
          @values.any?(&:god?)
        end

        def can_win?
          dragon_god = @values.find(&:dragon_god?)
          return true if dragon_god.nil?

          return true if dragon_god.evil? && @values.none?(&:good?)
          return true if dragon_god.good? && @values.none?(&:evil?)
        end
      end
    end
  end
end
