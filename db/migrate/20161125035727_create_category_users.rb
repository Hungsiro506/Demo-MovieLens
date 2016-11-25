class CreateCategoryUsers < ActiveRecord::Migration
  def change
    create_table :category_users do |t|
      t.references :user
      t.references :category
      t.boolean :like, default: true
      
      t.timestamps null: false
    end
  end
end
