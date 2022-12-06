class CreateUserMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :user_movies do |t|
      t.integer :movie_id
      t.integer :user_id

      t.timestamps
    end
  end
end
