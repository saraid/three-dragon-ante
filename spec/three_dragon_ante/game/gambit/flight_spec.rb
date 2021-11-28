RSpec.describe ThreeDragonAnte::Game::Gambit::Flight do
  let(:game) { ThreeDragonAnte::Game.new }
  let(:players) { 3.times.map { ThreeDragonAnte::Game::Player.new(game) } }
  let(:player) { players.first }
  let(:opponents) { players - [player] }

  let(:gambit) { ThreeDragonAnte::Game::Gambit.new(game) }

  subject { ThreeDragonAnte::Game::Gambit::Flight.new(game) }
  let(:deck) { ThreeDragonAnte::Deck.new }

  before(:each) do
    players.each { game.players << _1 }
    players.each { _1.hoard.gain 20 }
    players.each.with_index do |p, i|
      gambit.instance_variable_get(:@ante_cards) << deck.pull_card(
        strength: 13 - i, is_not: [ThreeDragonAnte::Card::GoldDragon]
      )
    end
    gambit.stakes.gain 10
  end

  context 'when there are 3 dragons of the same color' do
    before(:each) do
      subject << deck.pull_card(type: ThreeDragonAnte::Card::GoldDragon, strength: 11)
      subject << deck.pull_card(type: ThreeDragonAnte::Card::GoldDragon, strength: 9)
      subject << deck.pull_card(type: ThreeDragonAnte::Card::GoldDragon, strength: 6)
      subject << deck.pull_card(type: ThreeDragonAnte::Card::BlackDragon)
    end

    describe '#color_flights' do
      it { expect(subject.color_flights.keys).to eq [ThreeDragonAnte::Card::GoldDragon] }
    end

    describe '#check_special_flight_completion!' do
      it 'should steal gold from opponents' do
        opponent_hoards = opponents.map(&:hoard).map(&:value)
        player_hoard = player.hoard.value

        subject.check_special_flight_completion!(gambit, player)

        opponents.size.times do |i|
          expect(opponents[i].hoard.value).to eq(opponent_hoards[i] - 9)
        end
      end
    end
  end

  context 'when there are 3 dragons of the same strength' do
    before(:each) do
      subject << deck.pull_card(strength: 2)
      subject << deck.pull_card(strength: 2)
      subject << deck.pull_card(strength: 2)
      subject << deck.pull_card(strength: 13)
    end

    describe '#strength_flights' do
      it { expect(subject.strength_flights.keys).to eq [2] }
    end

    describe '#check_special_flight_completion!' do
      it 'should steal gold from stakes' do
        current_stakes = gambit.stakes.value
        player_hoard = player.hoard.value

        subject.check_special_flight_completion!(gambit, player)

        expect(gambit.stakes.value).to eq(current_stakes - 2)
      end

      it 'should steal 2 cards from the ante' do
        current_ante = gambit.ante.size

        subject.check_special_flight_completion!(gambit, player)
        player.current_choice.choose! 0
        player.current_choice.choose! 1

        expect(gambit.ante.size).to eq 1
      end
    end
  end
end
