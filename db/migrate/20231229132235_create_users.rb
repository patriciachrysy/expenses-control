class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :photo
      t.string :role, default: 'user'

      t.index :name, unique: true

      t.timestamps
    end
  end
end
