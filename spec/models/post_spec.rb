require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーション' do
    it '有効なファクトリを持つこと' do
      user = create(:user)
      post = build(:post, :with_image, user: user)
      expect(post).to be_valid
    end

    describe 'content' do
      it '2200文字以下であること' do
        user = create(:user)
        post = build(:post, :with_image, content: 'a' * 2201, user: user)
        post.valid?
        expect(post.errors[:content]).to include('is too long (maximum is 2200 characters)')
      end
    end

    describe 'images' do
      it '画像が存在しないと無効であること' do
        user = create(:user)
        post = build(:post, user: user)
        post.valid?
        expect(post.errors[:images]).to include("can't be blank")
      end
    end

    describe 'user' do
      it 'ユーザーが存在しないと無効であること' do
        post = build(:post, :with_image, user: nil)
        post.valid?
        expect(post.errors[:user]).to include('must exist')
      end
    end
  end

  describe '関連付け' do
    it { should belong_to(:user) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:liked_users) }
  end

  describe '#liked_by?' do
    let(:user) { create(:user) }
    let(:post) { create(:post, :with_image) }

    it 'ユーザーがいいねしている場合trueを返すこと' do
      post.likes.create(user: user)
      expect(post.liked_by?(user)).to be true
    end

    it 'ユーザーがいいねしていない場合falseを返すこと' do
      expect(post.liked_by?(user)).to be false
    end
  end

  describe 'scope' do
    describe '.recent' do
      it '新しい順に並ぶこと' do
        old_post = create(:post, :with_image, created_at: 2.days.ago)
        new_post = create(:post, :with_image, created_at: 1.day.ago)
        
        expect(Post.recent).to eq([new_post, old_post])
      end
    end
  end
end