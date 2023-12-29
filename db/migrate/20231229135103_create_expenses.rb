class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.text :description, null: false
      t.float :amount, null: false

      t.timestamps
    end
  end
end
