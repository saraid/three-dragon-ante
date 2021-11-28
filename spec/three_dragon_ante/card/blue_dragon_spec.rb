RSpec.describe ThreeDragonAnte::Card::BlueDragon do
  let(:target_phase) { [:gambit, 1, :round, 1, :aleph] }
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),

    # Then aleph will play a blue dragon
    { type: ThreeDragonAnte::Card::BlueDragon },
  ] end

  let(:game) { Factory.game(setup_until: target_phase, stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    it 'offers a choice' do
      game.players[0].current_choice.choose! 0
      expect(game.players[0].current_choice.prompt).to eq :choose_one
      expect(game.players[0].current_choice.choices.size).to eq 2
    end

    context 'and the player chooses to steal from stakes' do
      before(:each) do
        gambit.current_round.run if target_phase[3] == 2
        game.players[0].current_choice.choose! 0 # play BlueDragon
      end

      context 'and the player has no evil dragons except the blue' do
        it 'should steal 1 gold from stakes' do
          current_stakes = gambit.stakes.value
          current_hoard = game.players[0].hoard.value
          game.players[0].current_choice.choose! :steal_from_stakes
          expect(game.players[0].hoard.value).to eq(current_hoard + 1)
          expect(gambit.stakes.value).to eq(current_stakes - 1)
        end
      end

      context 'and the player has multiple evil dragons' do
        let(:target_phase) { [:gambit, 1, :round, 2, :aleph] }
        let(:stacked_deck) { [
          *Factory.ante_to_choose_leader(:aleph),
          *Factory.flights(flights: {
            aleph: [{ tags: %i(evil), is_not: [ThreeDragonAnte::Card::BlueDragon],
                      strength: cmp(:>, 3), no_manip: %i(hands) },
                    { type: ThreeDragonAnte::Card::BlueDragon }],
            bet: [{ strength: cmp(:<, 3), no_manip: %i(hands) }],
            gimel: [{ strength: cmp(:<, 3), no_manip: %i(hands) }],
          })
        ] }

        it 'should steal 2 gold from stakes' do
          current_stakes = gambit.stakes.value
          current_hoard = game.players[0].hoard.value
          game.players[0].current_choice.choose! :steal_from_stakes
          expect(game.players[0].hoard.value).to eq(current_hoard + 2)
          expect(gambit.stakes.value).to eq(current_stakes - 2)
        end
      end
    end

    context 'and the player chooses to make players pay to stakes' do
      before(:each) do
        gambit.current_round.run if target_phase[3] == 2
        game.players[0].current_choice.choose! 0 # play BlueDragon
      end

      context 'and the player has no evil dragons except the blue' do
        it 'should make others pay 1 gold to stakes' do
          current_stakes = gambit.stakes.value
          player_hoards = game.players[1..-1].map(&:hoard).map(&:value)
          game.players[0].current_choice.choose! :others_pay_into_stakes
          expect(gambit.stakes.value).to eq(current_stakes + game.players.size - 1) # (players-1)*1
          game.players[1..-1].each.with_index do |player, index|
            expect(player.hoard.value).to eq(player_hoards[index] - 1)
          end
        end
      end

      context 'and the player has multiple evil dragons' do
        let(:target_phase) { [:gambit, 1, :round, 2, :aleph] }
        let(:stacked_deck) { [
          *Factory.ante_to_choose_leader(:aleph),
          *Factory.flights(flights: {
            aleph: [{ tags: %i(evil), is_not: [ThreeDragonAnte::Card::BlueDragon],
                      strength: cmp(:>, 3), no_manip: %i(hands) },
                    { type: ThreeDragonAnte::Card::BlueDragon }],
            bet: [{ strength: cmp(:<=, 3), no_manip: %i(hands) }],
            gimel: [{ strength: cmp(:<=, 3), no_manip: %i(hands) }],
          })
        ] }

        it 'should make others pay 2 gold to stakes' do
          current_stakes = gambit.stakes.value
          player_hoards = game.players[1..-1].map(&:hoard).map(&:value)
          game.players[0].current_choice.choose! :others_pay_into_stakes
          expect(gambit.stakes.value).to eq(current_stakes + (game.players.size - 1)*2) # (players-1)*2
          game.players[1..-1].each.with_index do |player, index|
            expect(player.hoard.value).to eq(player_hoards[index] - 2)
          end
        end
      end
    end
  end
end
