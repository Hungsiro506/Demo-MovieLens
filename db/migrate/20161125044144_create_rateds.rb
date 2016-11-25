class CreateRateds < ActiveRecord::Migration
  def change
    create_table :rateds do |t|
      t.references :user
      t.references :movie
      t.float :rate

      t.timestamps null: false
    end
  end
end
