class RenameHashesTable < ActiveRecord::Migration
	def change
		rename_table :hashes, :hashies
	end 
end
