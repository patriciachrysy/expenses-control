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
end
