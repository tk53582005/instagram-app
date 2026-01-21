require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '有効なファクトリを持つこと' do
      user = build(:user)
      expect(user).to be_valid
    end

    describe 'username' do
      it '存在しないと無効であること' do
        user = build(:user, username: nil)
        user.valid?
        expect(user.errors[:username]).to include("can't be blank")
      end

      it '一意でなければ無効であること' do
        create(:user, username: 'testuser')
        user = build(:user, username: 'testuser')
        user.valid?
        expect(user.errors[:username]).to include('has already been taken')
      end

      it '3文字未満の場合無効であること' do
        user = build(:user, username: 'ab')
        user.valid?
        expect(user.errors[:username]).to include('is too short (minimum is 3 characters)')
      end

      it '30文字を超える場合無効であること' do
        user = build(:user, username: 'a' * 31)
        user.valid?
        expect(user.errors[:username]).to include('is too long (maximum is 30 characters)')
      end

      it '英数字とアンダースコアのみ許可されること' do
        user = build(:user, username: 'test-user')
        user.valid?
        expect(user.errors[:username]).to include('は英数字とアンダースコアのみ使用できます')
      end
    end

    describe 'email' do
      it '存在しないと無効であること' do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end

      it '一意でなければ無効であること' do
        create(:user, email: 'test@example.com')
        user = build(:user, email: 'test@example.com')
        user.valid?
        expect(user.errors[:email]).to include('has already been taken')
      end
    end
  end

  describe '関連付け' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:active_follows).dependent(:destroy) }
    it { should have_many(:passive_follows).dependent(:destroy) }
    it { should have_many(:followings) }
    it { should have_many(:followers) }
  end

  describe 'フォロー機能' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    describe '#follow' do
      it '他のユーザーをフォローできること' do
        expect {
          user.follow(other_user)
        }.to change(user.followings, :count).by(1)
      end

      it '自分自身をフォローできないこと' do
        expect {
          user.follow(user)
        }.not_to change(user.followings, :count)
      end
    end

    describe '#unfollow' do
      it 'フォローを解除できること' do
        user.follow(other_user)
        expect {
          user.unfollow(other_user)
        }.to change(user.followings, :count).by(-1)
      end
    end

    describe '#following?' do
      it 'フォローしている場合trueを返すこと' do
        user.follow(other_user)
        expect(user.following?(other_user)).to be true
      end

      it 'フォローしていない場合falseを返すこと' do
        expect(user.following?(other_user)).to be false
      end
    end
  end
end