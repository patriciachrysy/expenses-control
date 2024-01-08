class Expense < ApplicationRecord
    belongs_to :author, class_name: 'User'
    has_many :category_expenses
    has_many :categories, through: :category_expenses

    validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 100 }
    validates :description, length: { minimum: 3, maximum: 400 }
    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

    def self.last_five_expenses_grouped_by_category
        Expense.joins(:categories)
               .order('expenses.created_at DESC') # Order by expenses.created_at
               .limit(5)
               .group('categories.id, expenses.created_at') # Include expenses.created_at in group by
               .select('categories.name as category_name, SUM(expenses.amount) as total_amount, expenses.*')
      end
      

    def self.expenses_by_category(category_id)
        Expense.joins(:categories)
               .where(category_id: category_id)
               .order(created_at: :desc)
    end

    def self.current_month_expenses
        start_of_month = Date.today.beginning_of_month
        end_of_month = Date.today.end_of_month
    
        Expense.joins(:categories)
               .where(created_at: start_of_month..end_of_month)
               .group('categories.id')
               .select('categories.name as category_name, SUM(expenses.amount) as total_amount, expenses.*')
    end

    def self.expenses_in_period(start_date, end_date)
        Expense.joins(:categories)
               .where(created_at: start_date..end_date)
               .group('categories.id')
               .select('categories.name as category_name, SUM(expenses.amount) as total_amount, expenses.*')
    end
end