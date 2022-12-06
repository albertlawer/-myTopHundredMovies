FactoryBot.define do
  factory :user do
    fullname {Faker::Name.unique.name}
    email {"#{fullname}@mail.com"}
    password {Faker::Internet.password}
  end
end
