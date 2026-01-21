class CreateFollows < ActiveRecord::Migration[7.2]
  def change
    create_table :follows do |t|
      t.integer :follower_id, null: false
      t.integer :following_id, null: false

      t.timestamps
    end
    
    # インデックスを追加（検索速度向上のため）
    add_index :follows, :follower_id
    add_index :follows, :following_id
    # 同じユーザーを2回フォローできないようにする
    add_index :follows, [:follower_id, :following_id], unique: true
    
    # 外部キー制約を追加
    add_foreign_key :follows, :users, column: :follower_id
    add_foreign_key :follows, :users, column: :following_id
  end
end