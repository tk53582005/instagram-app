require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:post) { create(:post, :with_image) }

    it '有効なファクトリを持つこと' do
      like = Like.new(user: user, post: post)
      expect(like).to be_valid
    end

    it '同じユーザーが同じ投稿に2回いいねできないこと' do
      Like.create(user: user, post: post)
      like = Like.new(user: user, post: post)
      like.valid?
      expect(like.errors[:user_id]).to include('has already been taken')
    end
  end

  describe '関連付け' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end