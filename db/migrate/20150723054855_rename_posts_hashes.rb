class RenamePostsHashes < ActiveRecord::Migration
	def change
		rename_table :posts_hashes, :post_hashies
	end 
end

