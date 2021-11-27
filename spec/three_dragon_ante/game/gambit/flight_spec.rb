RSpec.describe ThreeDragonAnte::Game::Gambit::Flight do
  subject { ThreeDragonAnte::Game::Gambit::Flight.new(ThreeDragonAnte::Game.new) }
  let(:deck) { ThreeDragonAnte::Deck.new }

  context 'when there are 3 dragons of the same color' do
    before(:each) do
      subject << deck.pull_card(type: ThreeDragonAnte::Card::GoldDragon, strength: 11)
      subject << deck.pull_card(type: ThreeDragonAnte::Card::GoldDragon, strength: 9)
      subject << deck.pull_card(type: ThreeDragonAnte::Card::GoldDragon, strength: 6)
      subject << deck.pull_card(type: ThreeDragonAnte::Card::BlackDragon)
    end

    describe '#color?' do
      it { expect(subject.color?).to eq true }
    end

    describe '#payment_for_color_flight' do
      it { expect(subject.payment_for_color_flight).to eq 9 }
    end
  end

  context 'when there are 3 dragons of the same strength' do
    before(:each) do
      subject << deck.pull_card(strength: 2)
      subject << deck.pull_card(strength: 2)
      subject << deck.pull_card(strength: 2)
      subject << deck.pull_card(strength: 13)
    end

    describe '#strength?' do
      it { expect(subject.strength?).to eq true }
    end

    describe '#payment_for_strength_flight' do
      it { expect(subject.payment_for_strength_flight).to eq 2 }
    end
  end
end
