class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts
	do |t|
		t.string :caption
		t.string :location #need geo-tag!?!?
		t.datetime :created_at
		t.datetime :updated_at
		t.string :image_url
		t.integer :user_id
	end
  end
end
