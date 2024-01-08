require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { User.create(name: 'John Doe', email: 'test@example.com', password: 'password123') }
  describe 'validations' do
    it 'validates presence, uniqueness, length, and numericality' do
      existing_expense = Expense.create(name: 'Existing Expense', description: 'Description', amount: 50, author: user)

      expense = Expense.new(name: nil, description: 'Some description', amount: 100, author: user)
      expense.valid?

      expect(expense.errors[:name]).to include("can't be blank")
      expect(expense.errors[:name]).to include('is too short (minimum is 3 characters)')

      expense.name = existing_expense.name # Existing expense name
      expense.valid?
      expect(expense.errors[:name]).to include('has already been taken')

      expense.name = 'New Expense Name'
      expense.description = 'A' * 2 # Below minimum length
      expense.valid?
      expect(expense.errors[:description]).to include('is too short (minimum is 3 characters)')

      expense.description = 'Description'
      expense.amount = -10 # Negative amount
      expense.valid?
      expect(expense.errors[:amount]).to include('must be greater than or equal to 0')
    end
  end

  describe 'associations' do
    it 'belongs to author (User)' do
      association = described_class.reflect_on_association(:author)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:class_name]).to eq 'User'
    end

    it 'has many category_expenses' do
      association = described_class.reflect_on_association(:category_expenses)
      expect(association.macro).to eq :has_many
    end

    it 'has many categories through category_expenses' do
      association = described_class.reflect_on_association(:categories)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :category_expenses
    end
  end

  describe 'scopes and methods' do
    before do
      @category1 = Category.create(name: 'Category 1', icon: 'icon', user: user)
      @category2 = Category.create(name: 'Category 2', icon: 'icon', user: user)
      @expense1 = Expense.create(name: 'Expense 1', description: 'Desc 1', amount: 100, author: user)
      @expense1.categories << [@category1, @category2]
      @expense2 = Expense.create(name: 'Expense 2', description: 'Desc 2', amount: 200, author: user)
      @expense2.categories << @category1
      @expense3 = Expense.create(name: 'Expense 3', description: 'Desc 3', amount: 150, author: user)
      @expense3.categories << @category2
      @expense4 = Expense.create(name: 'Expense 4', description: 'Desc 4', amount: 120, author: user)
      @expense5 = Expense.create(name: 'Expense 5', description: 'Desc 5', amount: 180, author: user)
    end

    it 'returns last five expenses grouped by category' do
      expect(Expense.last_five_expenses_grouped_by_category.size).to eq(4)
    end

    it 'returns expenses by category' do
      expect(Expense.expenses_by_category(@category1.id).size).to eq(2)
    end

    it 'returns current month expenses' do
      expect(Expense.current_month_expenses.size).to eq(4)
    end

    it 'returns expenses in a given period' do
      start_date = 1.month.ago.to_date
      end_date = Date.today
      expect(Expense.expenses_in_period(start_date, end_date).size).to eq(5)
    end
  end
end
