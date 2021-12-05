module ThreeDragonAnte
  class Game
    class Event
      class Details
        def self.[](*args, **kwargs)
          new(*args, **kwargs)
        end
      end
    end
  end
end

require_relative './array_changed'
require_relative './ante_changed'
require_relative './player_flight_changed'
require_relative './player_hand_changed'
require_relative './player_hoard_debts_changed'

require_relative './integer_changed'
require_relative './player_hoard_changed'
require_relative './gambit_stakes_changed'

require_relative './ante_revealed'
require_relative './ante_tied'
require_relative './choice_made'
require_relative './choice_offered'
require_relative './leader_chosen'
require_relative './special_flight_completed'
