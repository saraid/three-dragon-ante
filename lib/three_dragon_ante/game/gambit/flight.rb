module ThreeDragonAnte
  class Game
    class Gambit
      class Flight < Evented::SetOfCards
        def check_special_flight_completion!(gambit, player)
          @special_completed ||= { color: false, strength: false }
          if !@special_completed[:color] && color?
            @special_completed[:color] = true
            (gambit.game.players.value - player).each do |opponent|
              cash = payment_for_color_flight
              player.gain opponent.hoard.lose(cash, to: player)
            end
            game << [player, :color_flight]
          end
          if !@special_completed[:strength] && color?
            @special_completed[:strength] = true
            player.hoard.gain(gambit.stakes.lose(payment_for_strength_flight))
            game << [player, :strength_flight]
          end
        end

        def color?
          @values.select(&:dragon?).group_by(&:class).any? { _2.size == 3 }
        end

        def payment_for_color_flight
          @values.select(&:dragon?).group_by(&:class).select { _2.size == 3 }.values.first[1].strength
        end

        def strength?
          @values.select(&:dragon?).group_by(&:strength).any? { _2.size == 3 }
        end

        def payment_for_strength_flight
          @values.select(&:dragon?).group_by(&:strength).select { _2.size == 3 }.first.first
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
