module Factory
  PLAYER_IDENTIFIERS = %i( aleph bet gimel dalet he vav zayin chet tet yod kaf )
  def self.game(player_count: 3)
    ThreeDragonAnte::Game.new.tap do |game|
      player_count.times do |i|
        game.players << ThreeDragonAnte::Game::Player.new(game).tap do |player|
          player.identifier = PLAYER_IDENTIFIERS[i]
        end
      end
    end
  end
end
