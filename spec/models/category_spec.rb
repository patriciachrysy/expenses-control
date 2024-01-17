require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:user) { User.create(name: 'John Doe', email: 'test@example.com', password: 'password123') }

  describe 'validations' do
    it 'validates presence, uniqueness, length, and icon' do
      existing_category = Category.create(name: 'Existing Category', icon: 'icon-name', user:)

      category = Category.new(name: nil, icon: nil)
      category.valid?

      expect(category.errors[:name]).to include("can't be blank")
      expect(category.errors[:icon]).to include("can't be blank")

      category.name = 'A' * 2 # Below minimum length
      category.icon = 'icon-name'
      category.valid?
      expect(category.errors[:name]).to include('is too short (minimum is 3 characters)')

      category.name = existing_category.name # Existing category name
      category.icon = 'new-icon'
      category.valid?
      expect(category.errors[:name]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many category_expenses' do
      association = described_class.reflect_on_association(:category_expenses)
      expect(association.macro).to eq :has_many
    end

    it 'has many expenses through category_expenses' do
      association = described_class.reflect_on_association(:expenses)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :category_expenses
    end
  end

  describe 'scopes' do
    it 'orders categories by created_at in descending order' do
      category1 = Category.create(name: 'Category 1', icon: 'icon', created_at: 3.days.ago, user:)
      category2 = Category.create(name: 'Category 2', icon: 'icon', created_at: 2.days.ago, user:)
      category3 = Category.create(name: 'Category 3', icon: 'icon', created_at: 1.day.ago, user:)

      categories = Category.all_categories

      expect(categories).to eq([category3, category2, category1])
    end
  end
end
