require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:post) { create(:post, :with_image) }

    it '有効なファクトリを持つこと' do
      comment = Comment.new(content: 'テストコメント', user: user, post: post)
      expect(comment).to be_valid
    end

    it 'contentが存在しないと無効であること' do
      comment = Comment.new(content: nil, user: user, post: post)
      comment.valid?
      expect(comment.errors[:content]).to include("can't be blank")
    end
  end

  describe '関連付け' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end