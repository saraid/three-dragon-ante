RSpec.describe ThreeDragonAnte::Deck do
  subject { ThreeDragonAnte::Deck.new }

  describe '#pull_card' do
    context 'with no parameters' do
      it 'should return a card' do
        expect(subject.pull_card).to be_a(ThreeDragonAnte::Card)
      end
    end

    context 'with type parameter' do
      it' should return a card of the correct type' do
        type = ThreeDragonAnte::Card::BlackDragon
        actual = subject.pull_card(type: type)
        expect(actual).to be_a(type)
      end
    end

    context 'with strength parameter' do
      it 'should return a card of the exact strength' do
        strength = rand(1..13)
        expect(subject.pull_card(strength: strength).strength).to eq strength
      end

      it 'should return a card of specified strength' do
        expect(subject.pull_card(strength: proc { _1 > 5 }).strength).to be > 5
      end
    end

    context 'with tags parameter' do
      it 'should return a card with the correct tags' do
        tags = %i( good )
        expect(subject.pull_card(tags: tags)).to be_good
      end

      it 'should return a card with the correct tags' do
        tags = %i( good dragon )
        actual = subject.pull_card(tags: tags)
        expect(actual).to be_good
        expect(actual).to be_dragon
      end
    end

    context 'with combinations' do
      it 'have the correct result' do
        actual = subject.pull_card(type: ThreeDragonAnte::Card::RedDragon, strength: 8)
        expect(actual.strength).to eq(8)
        expect(actual).to be_a ThreeDragonAnte::Card::RedDragon
      end
    end

    context 'with is_not parameter' do
      it 'should remove is_not[type]' do
        actual = subject.pull_card(is_not: [ThreeDragonAnte::Card::TheFool])
        expect(actual).not_to be_a ThreeDragonAnte::Card::TheFool
      end

      it 'should remove is_not[tag]' do
        actual = subject.pull_card(is_not: %i( dragon ))
        expect(actual.tags).not_to include :dragon
      end
    end
  end
end
