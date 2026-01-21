require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe 'バリデーション' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it '有効なファクトリを持つこと' do
      follow = Follow.new(follower: user1, following: user2)
      expect(follow).to be_valid
    end

    it 'follower_idが存在しないと無効であること' do
      follow = Follow.new(follower_id: nil, following: user2)
      follow.valid?
      expect(follow.errors[:follower_id]).to include("can't be blank")
    end

    it 'following_idが存在しないと無効であること' do
      follow = Follow.new(follower: user1, following_id: nil)
      follow.valid?
      expect(follow.errors[:following_id]).to include("can't be blank")
    end

    it '同じユーザーを2回フォローできないこと' do
      Follow.create(follower: user1, following: user2)
      follow = Follow.new(follower: user1, following: user2)
      follow.valid?
      expect(follow.errors[:follower_id]).to include('has already been taken')
    end

    it '自分自身をフォローできないこと' do
      follow = Follow.new(follower: user1, following: user1)
      follow.valid?
      expect(follow.errors[:base]).to include('自分自身をフォローすることはできません')
    end
  end

  describe '関連付け' do
    it { should belong_to(:follower).class_name('User') }
    it { should belong_to(:following).class_name('User') }
  end
end