module ThreeDragonAnte
  class Game
    class Gambit
      class Flight < Evented::SetOfCards
        def color?
          @values.select(&:dragon?).group_by(&:class).any? { _2.size >= 3 }
        end

        # FIXME: THis basically relies on a low probability of edge cases
        def payment_for_color_flight
          return 0 unless color?
          @values.select(&:dragon?).group_by(&:class).select { _2.size >= 3 }.values.first[1].strength
        end

        def strength?
          @values.select(&:dragon?).group_by(&:strength).any? { _2.size >= 3 }
        end

        # FIXME: THis basically relies on a low probability of edge cases
        def payment_for_strength_flight
          return 0 unless strength?
          @values.select(&:dragon?).group_by(&:strength).select { _2.size >= 3 }.first.first
        end
      end
    end
  end
end
