class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = Category.all.includes(:expenses)
  end

  def show
    @category = current_user.categories.includes(:expenses).find(params[:id])
  end

  def new
    @category = current_user.categories.new
  end

  def create
    @category = current_user.categories.new(category_params)
    authorize! :create, Category

    if @category.save
      flash[:notice] = "#{@category.name} was successfully created"
      redirect_to categories_path
    else
      flash[:alert] = 'The category could not be saved, please check the form and try again'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = current_user.categories.find(params[:id])
  end

  def update
    @category = current_user.categories.find(params[:id])
    authorize! :update, @category

    if @category.update(category_params)
      flash[:notice] = 'The category was successfully updated'
      redirect_to categories_path
    else
      flash[:alert] = 'The category could not be updated, please check the form and try again'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = current_user.categories.includes(:expenses).find(params[:id])
    authorize! :destroy, @category

    if @category.expenses.count.positive?
      flash[:notice] = 'The Category could not be deleted, it is already associated to some expenses.'
    else
      @category.destroy
      flash[:notice] = 'The category was successfully deleted'
    end
    redirect_to categories_path, status: :see_other
  end

  private

  def category_params
    params.require(:category).permit(:name, :icon)
  end
end
