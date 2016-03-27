class AddToHashesTable < ActiveRecord::Migration
  def change
  	add_column(:hashes, :updated_at, :datetime)
  end
end
