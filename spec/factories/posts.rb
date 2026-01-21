FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph }
    association :user
    
    # 画像付きの投稿用
    trait :with_image do
      after(:build) do |post|
        post.images.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'test_image.jpg')),
          filename: 'test_image.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end