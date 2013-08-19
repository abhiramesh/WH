class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
    	t.integer :user_id
    	t.string :query
    	t.string :name
    	t.string :image_url
      t.timestamps
    end
  end
end
