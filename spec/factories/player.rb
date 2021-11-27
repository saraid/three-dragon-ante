module Factory
  PLAYER_IDENTIFIERS = %i( aleph bet gimel dalet he vav zayin chet tet yod kaf )

  def self.player(game, identifier)
    ThreeDragonAnte::Game::Player.new(game).tap do |player|
      player.identifier = identifier
    end
  end
end
