require 'rails_helper'

RSpec.describe ExpensesManagerController, type: :controller do
  let(:user) do
    user = User.new(name: 'Test User', email: 'test@example.com', password: 'password')
    user.confirm
    user
  end
  let(:category) { Category.create(name: 'Groceries', icon: 'food', user:) }
  let(:expense_params) { { name: 'Grocery shopping', amount: 50, description: 'Weekly grocery expenses' } }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns @expenses' do
      expense = Expense.create(name: 'Shopping', amount: 30, description: 'Shopping expenses', author: user)
      get :index
      expect(assigns(:expenses)).to eq([expense])
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      expense = Expense.create(name: 'Shopping', amount: 30, description: 'Shopping expenses', author: user)
      get :show, params: { id: expense.id }
      expect(response).to render_template(:show)
    end

    it 'assigns @expense' do
      expense = Expense.create(name: 'Shopping', amount: 30, description: 'Shopping expenses', author: user)
      get :show, params: { id: expense.id }
      expect(assigns(:expense)).to eq(expense)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new, params: { category_id: category.id }
      expect(response).to render_template(:new)
    end

    it 'assigns @category and @expense' do
      get :new, params: { category_id: category.id }
      expect(assigns(:category)).to eq(category)
      expect(assigns(:expense)).to be_a_new(Expense)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new expense' do
        expect do
          post :create, params: { category_id: category.id, expense: expense_params }
        end.to change(Expense, :count).by(1)
      end

      it 'creates a new category_expense record' do
        expect do
          post :create, params: { category_id: category.id, expense: expense_params }
        end.to change(CategoryExpense, :count).by(1)
      end

      it 'redirects to the category path' do
        post :create, params: { category_id: category.id, expense: expense_params }
        expect(response).to redirect_to(category_path(category))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new expense' do
        expect do
          post :create, params: { category_id: category.id, expense: { name: '' } }
        end.to_not change(Expense, :count)
      end

      it 'renders the new template' do
        post :create, params: { category_id: category.id, expense: { name: '' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      expense = Expense.create(name: 'Shopping', amount: 30, description: 'Shopping expenses', author: user)
      get :edit, params: { category_id: category.id, id: expense.id }
      expect(response).to render_template(:edit)
    end

    it 'assigns @category and @expense' do
      expense = Expense.create(name: 'Shopping', amount: 30, description: 'Shopping expenses', author: user)
      get :edit, params: { category_id: category.id, id: expense.id }
      expect(assigns(:category)).to eq(category)
      expect(assigns(:expense)).to eq(expense)
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      it 'updates the expense' do
        expense = Expense.create(name: 'Shopping', amount: 30, description: 'Shopping expenses', author: user)
        put :update,
            params: { category_id: category.id, id: expense.id,
                      expense: { name: 'Grocery shopping', amount: 30,
                                 description: 'Shopping expenses', author: user } }
        expense.reload
        expect(expense.name).to eq('Grocery shopping')
      end

      it 'redirects to the category path' do
        expense = Expense.create(name: 'Shopping', amount: 30, description: 'Shopping expenses', author: user)
        put :update,
            params: { category_id: category.id, id: expense.id,
                      expense: { name: 'Grocery shopping', amount: 30,
                                 description: 'Shopping expenses', author: user } }
        expect(response).to redirect_to(category_path(category))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the expense' do
        expense = Expense.create(name: 'Shopping', amount: 30, description: 'Shopping expenses', author: user)
        put :update,
            params: { category_id: category.id, id: expense.id,
                      expense: { name: '', amount: 30, description: 'Shopping expenses', author: user } }
        expense.reload
        expect(expense.name).to eq('Shopping')
      end

      it 'renders the edit template' do
        expense = Expense.create(name: 'Shopping', amount: 30, description: 'Shopping expenses', author: user)
        put :update,
            params: { category_id: category.id, id: expense.id,
                      expense: { name: '', amount: 30, description: 'Shopping expenses', author: user } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the expense' do
      expense = Expense.create(name: 'Dinner', amount: 25, description: 'Dinner expenses', author: user)
      delete :destroy, params: { id: expense.id }
      expect(Expense.exists?(expense.id)).to be_falsey
    end

    it 'destroys the associated category_expense records' do
      expense = Expense.create(name: 'Dinner', amount: 25, description: 'Dinner expenses', author: user)
      category_expense = CategoryExpense.create(category:, expense:)
      delete :destroy, params: { id: expense.id }
      expect(CategoryExpense.exists?(category_expense.id)).to be_falsey
    end

    it 'redirects to the expenses path' do
      expense = Expense.create(name: 'Dinner', amount: 25, description: 'Dinner expenses', author: user)
      delete :destroy, params: { id: expense.id }
      expect(response).to redirect_to(expenses_manager_path)
    end
  end
end
