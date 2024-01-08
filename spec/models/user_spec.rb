require 'rails_helper'

RSpec.describe User, type: :model do
    describe 'validations' do
        it 'validates presence of email, password, and uniqueness of name' do
          User.create(email: 'john@example.com', password: 'password123', name: 'John Doe')
    
          user = User.new(email: nil, password: nil, name: 'John Doe')
          user.valid?
    
          expect(user.errors[:email]).to include("can't be blank")
          expect(user.errors[:password]).to include("can't be blank")
    
          expect(user.errors[:name]).to include('has already been taken')
        end
    end

  describe 'associations' do
    it 'has many categories' do
      expect(User.reflect_on_association(:categories).macro).to eq(:has_many)
    end

    it 'has many expenses with foreign key author_id' do
      expect(User.reflect_on_association(:expenses).macro).to eq(:has_many)
      expect(User.reflect_on_association(:expenses).options[:foreign_key]).to eq('author_id')
    end
  end

  describe 'devise modules' do
    it 'validates presence of email and password' do
      user = User.new
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
      expect(user.errors[:password]).to include("can't be blank")
    end
  end

  describe 'methods' do
    it 'checks if the user has a role' do
      user = User.new(name: 'John Doe')
      expect(user.is?('admin')).to be_falsey
    end
  end
end
