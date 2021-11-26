module Factory
  def self.game(player_count: 3)
    ThreeDragonAnte::Game.new.tap do |game|
      player_count.times do
        game.players << ThreeDragonAnte::Game::Player.new(game)
      end
    end
  end
end
