module Factory
  def self.game(player_count: 2)
    ThreeDragonAnte::Game.new.tap do |game|
      player_count.times do
        game.players << random_player
      end
    end
  end
end
