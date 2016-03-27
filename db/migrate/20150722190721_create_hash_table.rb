class CreateHashTable < ActiveRecord::Migration
	def change
		create_table :hashes do |t|
			t.string :word
			t.integer :post_id
			t.datetime :created_at
		end
	end
end
