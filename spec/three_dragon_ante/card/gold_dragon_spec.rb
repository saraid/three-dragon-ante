RSpec.describe ThreeDragonAnte::Card::GoldDragon do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),
    { type: ThreeDragonAnte::Card::GoldDragon },
  ] end

  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :aleph], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    context 'as the first card in flight' do
      it 'should draw 1 card' do
        expect(game.players[0].current_choice.choices.first).to be_a ThreeDragonAnte::Card::GoldDragon

        current_hand_size = game.players[0].hand.size
        game.players[0].current_choice.choose! 0
        expect(game.players[0].hand.size).to eq(current_hand_size) # card played (-1) card drawn (+1)
      end
    end

    context 'when there is already a good dragon in flight' do
      let(:stacked_deck) do [
        *Factory.ante_to_choose_leader(:aleph, but_not: ThreeDragonAnte::Card::GoldDragon),

        # Then aleph will play a gold dragon
        { type: ThreeDragonAnte::Card::GoldDragon, strength: cmp(:>, 5) },
        # Then bet will play a non-gold dragon
        { type: ThreeDragonAnte::Card::BlackDragon, strength: cmp(:<=, 5) },
        # Then gimel will play a non-gold dragon
        { type: ThreeDragonAnte::Card::BlackDragon, strength: cmp(:<=, 5) },

        # Then aleph will play a gold dragon
        { type: ThreeDragonAnte::Card::GoldDragon },
      ] end
      let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 2, :aleph], stacked_deck: stacked_deck) }

      it 'should draw 2 cards' do
        gambit.current_round.current_player_takes_turn
        expect(game.players[0].current_choice.choices.first).to be_a ThreeDragonAnte::Card::GoldDragon

        current_hand_size = game.players[0].hand.size
        game.players[0].current_choice.choose! 0
        expect(game.players[0].hand.size).to eq(current_hand_size + 1) # card played (-1) cards drawn (+2)
      end
    end

    context 'when player hand size is at 10' do
      before(:each) do
        (ThreeDragonAnte::Game::Player::MAX_HAND_SIZE - game.players[0].hand.size).times do
          game.players[0].hand << game.deck.draw!
        end
      end

      it 'should draw no cards' do
        expect(game.players[0].current_choice.choices.first).to be_a ThreeDragonAnte::Card::GoldDragon

        current_hand_size = game.players[0].hand.size
        game.players[0].current_choice.choose! 0
        expect(game.players[0].hand.size).to eq(current_hand_size)
      end
    end
  end
end
