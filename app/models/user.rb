class User < ApplicationRecord
    has_many :categories
    has_many :expenses, foreign_key: 'author_id'
    
    validates :name, presence: true, uniqueness: true
end