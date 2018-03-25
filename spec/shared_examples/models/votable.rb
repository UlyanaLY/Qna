require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user)  { create(:user) }
  let(:other_user)  { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }

  describe '#voteup' do
    it 'creates new vote up' do
      expect { model.voteup(other_user) }.to change(model.votes, :count).by(1)
    end

    it 'change vote score by 1' do
      model.voteup(other_user)
      expect(model.votes.sum(:rating)).to eq(1)
    end

    it 'destroys vote if one already exist' do
      2.times { model.voteup(other_user) }
      expect(model.votes.sum(:rating)).to eq(0)
    end
  end

  describe '#votedown' do
    it 'creates new vote down' do
      expect { model.votedown(other_user) }.to change(model.votes, :count).by(1)
    end

    it 'change vote score by -1' do
      model.votedown(other_user)
      expect(model.votes.sum(:rating)).to eq(-1)
    end

    it 'destroys vote if one already exist' do
      2.times { model.votedown(other_user) }
      expect(model.votes.sum(:rating)).to eq(0)
    end
  end
end