module ThreeDragonAnte
  class Game
    class Event
      class Phase
        def self.from_array(array_or_symbol)
          case array_or_symbol
          in :waiting_for_players then new(array_or_symbol)
          in :setup then new(array_or_symbol)
          in [:gambit, gambit_counter] then new(:play, gambit_counter)
          in [:gambit, gambit_counter, :ante, ante_phase]
            new(:play, gambit_counter).tap { _1.ante_phase = ante_phase }
          in [:gambit, gambit_counter, :round, round_counter]
            new(:play, gambit_counter).tap { _1.round_counter = round_counter }
          in [:gambit, gambit_counter, :round, round_counter, current_player]
            new(:play, gambit_counter).tap do
              _1.round_counter = round_counter
              _1.turn_player = current_player
            end
          in [:gambit, gambit_counter, :distribute_stakes]
            new(:play, gambit_counter).tap { _1.gambit_phase = :distribute_stakes }
          in [:gambit, gambit_counter, :cleanup]
            new(:play, gambit_counter).tap { _1.gambit_phase = :cleanup }
          end
        end

        def initialize(game_phase, gambit_counter = nil)
          @game_phase, @gambit_counter = game_phase, gambit_counter
        end
        attr_accessor :ante_phase, :gambit_phase, :round_counter, :turn_player

        def to_s
          as_tuple.yield_self { _1.size == 1 ? _1.first : _1 }.to_s
        end

        def as_tuple
          return [@game_phase] unless @game_phase == :play
          [].tap { _1 << :gambit << @gambit_counter if @gambit_counter }
            .tap { _1 << @gambit_phase if @gambit_phase }
            .tap { _1 << :ante << @ante_phase if @ante_phase }
            .tap { _1 << :round << @round_counter if @round_counter }
            .tap { _1 << :turn << @turn_player if @turn_player }
        end
      end
    end
  end
end
