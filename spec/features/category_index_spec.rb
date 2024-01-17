# spec/features/categories/index_spec.rb

require 'rails_helper'

RSpec.feature 'Categories Index Page', type: :feature do
  let(:user) do
    user = User.new(name: 'Test User', email: 'test@example.com', password: 'password')
    user.confirm
    user
  end
  let(:category1) { Category.create(name: 'Category 1', icon: 'icon1', user:) }
  let(:category2) { Category.create(name: 'Category 2', icon: 'icon2', user:) }

  before do
    sign_in user
  end

  scenario 'displays categories when there are some' do
    category1
    category2

    visit categories_path

    expect(page).to have_content(category2.name)
    expect(page).to have_content(category1.created_at.strftime('%B %d, %Y'))
    expect(page).to have_content("$#{category1.expenses.sum(&:amount)}")
    expect(page).to have_content("$#{category2.expenses.sum(&:amount)}")
  end

  scenario 'displays link to add category when none present' do
    visit categories_path

    expect(page).to have_link('click', href: new_category_path)
  end

  scenario 'displays update and delete links for each category' do
    category1
    category2

    visit categories_path

    expect(page).to have_link('', href: edit_category_path(category1))
    expect(page).to have_link('', href: category_path(category2))
  end
end
