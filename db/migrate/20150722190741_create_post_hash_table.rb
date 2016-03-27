class CreatePostHashTable < ActiveRecord::Migration
	def change
		create_table :posts_hashes do |t|
			t.integer :post_id 
			t.integer :hash_id
		end
	end
end
