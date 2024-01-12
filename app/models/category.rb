class Category < ApplicationRecord
  belongs_to :user
  has_many :category_expenses
  has_many :expenses, through: :category_expenses

  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 100 }
  validates :icon, presence: true

  scope :all_categories, -> { order(created_at: :desc) }

  def display_icon
    "<i class='las la-#{icon}'></i>".html_safe
  end
end
