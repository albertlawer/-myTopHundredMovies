class User < ApplicationRecord
    validates :fullname, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true
end
