class AddTitleToUserMovie < ActiveRecord::Migration[7.0]
  def change
    add_column :user_movies, :title, :string
  end
end
