require 'rails_helper'

RSpec.describe User, type: :model do
  describe "# Validations" do
    it "should validate factory" do
      a_user = build(:user)
      expect(a_user).to be_valid
    end

    it "should validate attributes" do
      new_user = User.new
      expect(new_user).not_to be_valid
    end

    it "should validate uniqueness" do
      email = Faker::Internet.email
      user_one = User.create(fullname: Faker::Name.unique.name, email: email, password: Faker::Internet.password)
      user_two = User.create(fullname: Faker::Name.unique.name, email: email, password: Faker::Internet.password)
      expect(user_two).not_to be_valid
    end
  end
end
