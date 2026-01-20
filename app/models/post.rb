class Post < ApplicationRecord
  belongs_to :user

  # 複数画像の関連付け
  has_many_attached :images

  # いいねの関連付け
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  # コメントの関連付け
  has_many :comments, dependent: :destroy

  # バリデーション
  validates :content, length: { maximum: 2200 }
  validates :images, presence: true

  # 新しい順に並べる
  scope :recent, -> { order(created_at: :desc) }

  # 特定のユーザーがいいねしているか確認
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end
