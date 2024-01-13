class ExpensesManagerController < ApplicationController
  before_action :authenticate_user!

  def index
    @expenses = current_user.expenses.ordered_expenses.includes(:categories)
  end

  def show
    @expense = current_user.expenses.includes(:categories).find(params[:id])
  end

  def new
    @category = current_user.categories.find(params[:category_id])
    @expense = current_user.expenses.new
  end

  def create
    @category = current_user.categories.find(params[:category_id])
    @expense = current_user.expenses.new(name: params[:expense][:name], amount: params[:expense][:amount],
                                         description: params[:expense][:description], photo: params[:expense][:photo])
    authorize! :create, Expense

    if @expense.save
      CategoryExpense.create(category_id: @category.id, expense_id: @expense.id)
      if params[:expense][:categories].present?
        params[:expense][:categories].each do |category|
          if CategoryExpense.find_by(category_id: category, expense_id: @expense.id).nil?
            CategoryExpense.create(category_id: category, expense_id: @expense.id)
          end
        end
      end
      flash[:notice] = "#{@expense.name} was successfully created"
      redirect_to category_path(@category)
    else
      flash[:alert] = 'The expense could not be saved, please check the form and try again'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = current_user.categories.find(params[:category_id])
    @expense = current_user.expenses.find(params[:id])
  end

  def update
    @category = current_user.categories.find(params[:category_id])
    @expense = current_user.expenses.find(params[:id])
    authorize! :create, Expense

    if @expense.update(expenses_params)
      @expense.category_expenses.destroy_all
      CategoryExpense.create(category_id: @category.id, expense_id: @expense.id)
      if params[:expense][:categories].present?
        params[:expense][:categories].each do |category|
          if CategoryExpense.find_by(category_id: category, expense_id: @expense.id).nil?
            CategoryExpense.create(category_id: category, expense_id: @expense.id)
          end
        end
      end
      flash[:notice] = "#{@expense.name} was successfully updated"
      redirect_to category_path(@category)
    else
      flash[:alert] = 'The expense could not be saved, please check the form and try again'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense = current_user.expenses.includes(:category_expenses).find(params[:id])
    authorize! :destroy, @expense

    @expense.category_expenses.destroy_all
    @expense.destroy
    flash[:notice] = 'The expense was successfully deleted'

    redirect_to expenses_manager_path, status: :see_other
  end

  private

  def expenses_params
    params.require(:expense).permit(:name, :amount, :description, :photo, categories: [])
  end
end
