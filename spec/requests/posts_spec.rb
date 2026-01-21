require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET /posts" do
    context 'ログインしている場合' do
      before { sign_in user }

      it '正常にレスポンスを返すこと' do
        get posts_path
        expect(response).to have_http_status(:success)
      end

      it 'タイムラインが表示されること' do
        get posts_path
        expect(response.body).to include('タイムライン')
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        get posts_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /posts/new" do
    context 'ログインしている場合' do
      before { sign_in user }

      it '正常にレスポンスを返すこと' do
        get new_post_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        get new_post_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /posts" do
    context 'ログインしている場合' do
      before { sign_in user }

      context '有効なパラメータの場合' do
        it '投稿が作成されること' do
          expect {
            post posts_path, params: {
              post: {
                content: 'テスト投稿',
                images: [fixture_file_upload('spec/fixtures/test_image.jpg', 'image/jpeg')]
              }
            }
          }.to change(Post, :count).by(1)
        end

        it 'タイムラインにリダイレクトされること' do
          post posts_path, params: {
            post: {
              content: 'テスト投稿',
              images: [fixture_file_upload('spec/fixtures/test_image.jpg', 'image/jpeg')]
            }
          }
          expect(response).to redirect_to(posts_path)
        end
      end

      context '無効なパラメータの場合' do
        it '投稿が作成されないこと' do
          expect {
            post posts_path, params: {
              post: {
                content: 'テスト投稿'
                # 画像なし
              }
            }
          }.not_to change(Post, :count)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        post posts_path, params: {
          post: {
            content: 'テスト投稿',
            images: [fixture_file_upload('spec/fixtures/test_image.jpg', 'image/jpeg')]
          }
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /posts/:id" do
    let(:post_item) { create(:post, :with_image, user: user) }

    context 'ログインしている場合' do
      before { sign_in user }

      it '正常にレスポンスを返すこと' do
        get post_path(post_item)
        expect(response).to have_http_status(:success)
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        get post_path(post_item)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /posts/:id" do
    let!(:post_item) { create(:post, :with_image, user: user) }

    context '自分の投稿の場合' do
      before { sign_in user }

      it '投稿が削除されること' do
        expect {
          delete post_path(post_item)
        }.to change(Post, :count).by(-1)
      end

      it 'タイムラインにリダイレクトされること' do
        delete post_path(post_item)
        expect(response).to redirect_to(posts_path)
      end
    end

    context '他人の投稿の場合' do
      before { sign_in other_user }

      it '投稿が削除されないこと' do
        expect {
          delete post_path(post_item)
        }.not_to change(Post, :count)
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        delete post_path(post_item)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end