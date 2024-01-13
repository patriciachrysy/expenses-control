class AddPhotoToExpense < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :photo, :string
  end
end
