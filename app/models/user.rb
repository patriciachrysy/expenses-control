class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :categories
  has_many :expenses, foreign_key: 'author_id'

  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true

  def is?(requested_role)
    role == requested_role.to_s
  end
end
