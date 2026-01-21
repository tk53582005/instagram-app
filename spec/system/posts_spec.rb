require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    driven_by(:rack_test)
  end

  describe '投稿機能' do
    before do
      sign_in_as(user)
    end

    it '新規投稿ができること' do
      visit posts_path
      click_link '新規投稿'
      
      attach_file 'post[images][]', Rails.root.join('spec/fixtures/test_image.jpg')
      fill_in 'post[content]', with: 'テスト投稿です'
      click_button '投稿する'
      
      expect(page).to have_content 'テスト投稿です'
      expect(current_path).to eq posts_path
    end

    it '自分の投稿を削除できること' do
      post = create(:post, :with_image, user: user, content: '削除する投稿')
      
      visit post_path(post)
      click_link '削除'
      
      expect(current_path).to eq posts_path
      expect(page).not_to have_content '削除する投稿'
    end
  end

  describe 'いいね機能' do
    let!(:post_item) { create(:post, :with_image, user: other_user) }

    before do
      sign_in_as(user)
      visit posts_path
    end

    it 'いいねができること', js: true do
      within "#like-button-#{post_item.id}" do
        expect(page).to have_content '0'
        find('button[type="submit"]').click
        expect(page).to have_content '1'
      end
    end
  end

  describe 'コメント一覧表示' do
    let!(:post_item) { create(:post, :with_image, user: other_user) }
    let!(:comment) { Comment.create(content: '既存のコメント', user: user, post: post_item) }

    before do
      sign_in_as(user)
    end

    it '投稿詳細ページでコメントが表示されること' do
      visit post_path(post_item)
      
      expect(page).to have_content '既存のコメント'
      expect(page).to have_content user.username
    end
  end
end