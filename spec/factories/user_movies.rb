FactoryBot.define do
  factory :user_movie do
    movie_id { 1 }
    association :user
    title { Faker::Movie.title }
  end
end
