class CreateSearches < ActiveRecord::Migration[6.1]
  def change
    create_table :searches do |t|
      t.string :query
      t.integer :user_id
      t.datetime :search_time

      t.timestamps
    end
  end
end
