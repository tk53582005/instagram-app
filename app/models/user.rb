class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # プロフィール画像の関連付け
  has_one_attached :profile_image

  # 投稿との関連付け
  has_many :posts, dependent: :destroy

  # いいねの関連付け
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  # コメントの関連付け
  has_many :comments, dependent: :destroy

  # === フォロー機能 ===
  # 自分がフォローしている関係（能動的フォロー）
  has_many :active_follows, class_name: 'Follow', 
           foreign_key: 'follower_id', 
           dependent: :destroy
  
  # 自分がフォローされている関係（受動的フォロー）
  has_many :passive_follows, class_name: 'Follow', 
           foreign_key: 'following_id', 
           dependent: :destroy
  
  # フォローしているユーザー一覧
  has_many :followings, through: :active_follows, source: :following
  
  # フォロワー一覧
  has_many :followers, through: :passive_follows, source: :follower

  # バリデーション
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A[a-zA-Z0-9_]+\z/,
              message: "は英数字とアンダースコアのみ使用できます"
            },
            length: { minimum: 3, maximum: 30 }

  validates :name, length: { maximum: 50 }

  # プロフィール画像のURL取得
  def profile_image_url
    if profile_image.attached?
      Rails.application.routes.url_helpers.rails_blob_path(profile_image, only_path: true)
    else
      "/assets/default_profile.png"
    end
  end

  # === フォロー関連のヘルパーメソッド ===
  def follow(other_user)
    return if self == other_user
    active_follows.create(following_id: other_user.id)
  end
  
  def unfollow(other_user)
    active_follows.find_by(following_id: other_user.id)&.destroy
  end
  
  def following?(other_user)
    followings.include?(other_user)
  end
end