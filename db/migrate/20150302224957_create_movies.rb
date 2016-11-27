class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.integer :movielens_id
      t.string :title
      t.text :genres, array: true, default: []
      t.text :actors, array: true, default: []
      t.string  :year
      t.string 	:movie_type
    end
  end
end
