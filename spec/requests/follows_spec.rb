require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "POST /follows" do
    context 'ログインしている場合' do
      before { sign_in user }

      it 'フォローが作成されること' do
        expect {
          post follows_path, params: { following_id: other_user.id }
        }.to change(Follow, :count).by(1)
      end

      it 'フォロー数が増えること' do
        expect {
          post follows_path, params: { following_id: other_user.id }
        }.to change(user.followings, :count).by(1)
      end

      it 'HTMLリクエストの場合、プロフィールページにリダイレクトされること' do
        post follows_path, params: { following_id: other_user.id }
        expect(response).to redirect_to(profile_path(other_user.username))
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        post follows_path, params: { following_id: other_user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /follows/:id" do
    let!(:follow) { user.follow(other_user) }

    context 'ログインしている場合' do
      before { sign_in user }

      it 'フォローが削除されること' do
        expect {
          delete follow_path(follow)
        }.to change(Follow, :count).by(-1)
      end

      it 'フォロー数が減ること' do
        expect {
          delete follow_path(follow)
        }.to change(user.followings, :count).by(-1)
      end

      it 'HTMLリクエストの場合、プロフィールページにリダイレクトされること' do
        delete follow_path(follow)
        expect(response).to redirect_to(profile_path(other_user.username))
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        delete follow_path(follow)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end