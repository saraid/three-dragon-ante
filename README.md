# ThreeDragonAnte

Three Dragon Ante is a card game developed by Wizards of the Coast. It is meant to be a game thematic to D&D worlds that D&D characters can play.

This gem is a fun exercise for myself where I'm encoding all the rules. I may extend it to provide a server and client, too, if I become so inclined.

The rules can be found at [https://www.wizards.com/dnd/files/ThreeAnte_rulebook.zip](https://www.wizards.com/dnd/files/ThreeAnte_rulebook.zip) and some mre context on [Board Game Geek](https://boardgamegeek.com/boardgame/20806/three-dragon-ante).

My original, 2009, implementation can be found at [https://github.com/saraid/tda-server](https://github.com/saraid/tda-server).

I do not own Three Dragon Ante™.

## Usage

This codebase is designed to inter-operate with an unwritten server.

```ruby
include ThreeDragonAnte
game = Game.new
```

Add players to the game.

```ruby
game.players << Game::Player.new
game.players << Game::Player.new
game.players << Game::Player.new

# Remove players from the game.
game.players >> player
```

Initialize the game by distributing starting gold and hands.
```ruby
game.setup!
```
TODO: Change it so that newly joining players also receive setup.

Gambits come in three phases:
- Ante:
```ruby
game.current_gambit.accept_ante
game.players.each { _1.current_choice.choose!(0) }
game.current_gambit.reveal_ante 
game.current_gambit.choose_leader
game.current_gambit.pay_stakes
```

Rounds:
```ruby
game.players.size.times do
  game.current_gambit.current_round.current_player_takes_turn
end
```

Cleanup:
```ruby
game.current_gambit.distribute_stakes
game.current_gambit.cleanup
```

Player action is handled by an object called a `Game::Player::Choice`

A choice object has three salient methods:
- `prompt` is a key that explains the purpose of the choice.
- `choices` enumerates the possible options.
- `choose!` takes either an index of `choices` or one of the entries themselves and marks the choice as resolved.
```ruby
player = game.players[0]
player.current_choice.prompt
player.current_choice.choices
player.current_choice.choose! 0
```

It is possible for choices to be queued up such that a resolved choice is immediately followed by another choice.

The oldest pending choice for all players is exposed at:
```ruby
game.current_choices
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/saraid/three-dragon-ante.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
