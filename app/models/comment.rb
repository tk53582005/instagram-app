class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # バリデーション
  validates :content, presence: true, length: { maximum: 1000 }

  # 新しい順に並べる
  scope :recent, -> { order(created_at: :desc) }

  # @メンションされたユーザー名を抽出
  def mentioned_usernames
    content.scan(/@(\w+)/).flatten.uniq
  end
end