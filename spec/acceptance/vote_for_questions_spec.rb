require_relative 'acceptance_helper'

feature 'vote for question', %q{
  In order to vote
  As an user
  I want to be able vote for question
} do

  given(:user)       { create(:user) }
  given(:other_user) { create(:user) }
  given(:question)   { create(:question, user: user)  }

  scenario 'Author try vote for own question ', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_css ("a i.fa.fa-angle-up")
  end

  describe 'Authenticated user' do
    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'Authenticated user sees button vote for not own question ', js: true do
      expect(page).to have_css ("a i.fa.fa-angle-up")
    end

    scenario 'Authenticated user try vote for not own question ', js: true do
      find("a i.fa.fa-angle-up").click
      expect(page).to have_content "1"
    end

    scenario 'Authenticated user try negative vote for not own question ', js: true do
      find("a i.fa.fa-angle-down").click
      sleep 5
      expect(page).to have_content "-1"
    end

    scenario 'Authenticated user cancel vote for not own question ', js: true do
      find("a i.fa.fa-angle-up").click
      expect(page).to have_content "1"
      sleep 5
      find("a i.fa.fa-angle-down").click
      expect(page).to have_content "0"
    end
  end

  scenario 'NonAuthenticated user try vote for question' do
    visit question_path(question)

    expect(page).to_not have_css ("a i.fa.fa-angle-up")
  end

end