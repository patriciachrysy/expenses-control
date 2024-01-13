class Expense < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :category_expenses
  has_many :categories, through: :category_expenses

  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { minimum: 3, maximum: 400 }
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :ordered_expenses, -> { order(created_at: :desc) }

  def self.expenses_by_category(category_id)
    joins(:categories)
      .where(categories: { id: category_id })
      .order(created_at: :desc)
  end
end
