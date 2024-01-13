require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) do
    user = User.new(name: 'Test User', email: 'test@example.com', password: 'password')
    user.confirm
    user
  end
  let(:category) { Category.create(name: 'Test Category', icon: 'test-icon', user:) }
  let(:valid_attributes) { { name: 'New Category', icon: 'new-icon', user: } }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: category.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new category' do
        expect do
          post :create, params: { category: valid_attributes }
        end.to change(Category, :count).by(1)
      end

      it 'redirects to categories_path' do
        post :create, params: { category: valid_attributes }
        expect(response).to redirect_to(categories_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new category' do
        expect do
          post :create, params: { category: { name: nil, icon: 'new-icon', user: } }
        end.not_to change(Category, :count)
      end

      it 'renders the new template with status :unprocessable_entity' do
        post :create, params: { category: { name: nil, icon: 'new-icon', user: } }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { id: category.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the category' do
        patch :update, params: { id: category.id, category: { name: 'Updated Name' } }
        expect(category.reload.name).to eq('Updated Name')
      end

      it 'redirects to categories_path' do
        patch :update, params: { id: category.id, category: { name: 'Updated Name' } }
        expect(response).to redirect_to(categories_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the category' do
        original_name = category.name
        patch :update, params: { id: category.id, category: { name: nil } }
        expect(category.reload.name).to eq(original_name)
      end

      it 'renders the edit template with status :unprocessable_entity' do
        patch :update, params: { id: category.id, category: { name: nil } }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when there are no associated expenses' do
      it 'destroys the category' do
        category
        expect do
          delete :destroy, params: { id: category.id }
        end.to change(Category, :count).by(-1)
      end

      it 'redirects to categories_path' do
        delete :destroy, params: { id: category.id }
        expect(response).to redirect_to(categories_path)
      end
    end
  end
end
