# spec/features/categories/show_spec.rb

require 'rails_helper'

RSpec.feature 'Categories Show Page', type: :feature do
  let(:user) do
    user = User.new(name: 'Test User', email: 'test@example.com', password: 'password')
    user.confirm
    user
  end
  let(:category) { Category.create(name: 'Category 1', icon: 'icon1', user:) }
  let!(:expense1) { Expense.create(name: 'Expense 1', description: 'expense', amount: 50) }
  let!(:expensecategory1) { category.category_expenses.create(expense_id: expense1.id) }
  let!(:expense2) { Expense.create(name: 'Expense 2', description: 'expense', amount: 75) }
  let!(:expensecategory2) { category.category_expenses.create(expense_id: expense2.id) }

  before do
    sign_in user
  end

  scenario 'displays category details and total expenses' do
    visit category_path(category)

    expect(page).to have_content(category.name)
    expect(page).to have_content("$#{category.expenses.sum(&:amount)}")
  end
end
