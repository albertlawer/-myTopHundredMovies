require 'rails_helper'

RSpec.describe UserMovie, type: :model do
  describe "# Validations" do
    it "should validate factory" do
      a_user_movie = build(:user_movie)
      expect(a_user_movie).to be_valid
    end
  end
end
