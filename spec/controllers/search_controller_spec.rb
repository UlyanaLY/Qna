require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    sign_in_user

    it 'renders result viewer' do
      get :search
      expect(response).to render_template :search
    end

    %w(Everywhere Questions Answers Comments Users).each do |attr|
      it "search with params: #{attr}" do
        expect(Search).to receive(:find).with('something', attr)
        get :search, params: { query: 'something', category: attr }
        expect(response).to render_template :search
      end
    end
  end
end