require 'rails_helper'

RSpec.describe "Follows", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    driven_by(:rack_test)
    sign_in_as(user)
  end

  describe 'フォロー機能' do
    it 'ユーザーをフォローできること', js: true do
      visit profile_path(other_user.username)
      
      within "#follow-button-#{other_user.id}" do
        click_button 'フォローする'
        expect(page).to have_button 'フォロー中'
      end
      
      expect(page).to have_content '1 フォロワー'
    end

    it 'フォローを解除できること', js: true do
      user.follow(other_user)
      
      visit profile_path(other_user.username)
      
      within "#follow-button-#{other_user.id}" do
        click_button 'フォロー中'
        expect(page).to have_button 'フォローする'
      end
      
      expect(page).to have_content '0 フォロワー'
    end
  end

  describe 'フォロー一覧' do
    before do
      user.follow(other_user)
    end

    it 'フォロー中一覧が表示されること' do
      visit profile_path(user.username)
      click_link 'フォロー中', match: :first
      
      expect(page).to have_content "#{user.username} がフォローしているユーザー"
      expect(page).to have_content other_user.username
    end

    it 'フォロワー一覧が表示されること' do
      visit profile_path(other_user.username)
      click_link 'フォロワー', match: :first
      
      expect(page).to have_content "#{other_user.username} のフォロワー"
      expect(page).to have_content user.username
    end
  end
end