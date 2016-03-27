
#now that a users table has been created
#you need to have a class that models the database table.
#table names: PLURAL
#model names: SINGULAR

#user has posts and comments and votes

#posts belong to user


class User < ActiveRecord::Base 
	has_many :posts
end


class Post < ActiveRecord::Base
	belongs_to :user
	has_many :post_hashies
	has_many :hashes, through: :post_hashies
end


class Hashy < ActiveRecord::Base
	belongs_to :post
	has_many :post_hashies
	has_many :posts, through: :post_hashies
end

class PostHashy < ActiveRecord::Base
	belongs_to :post
	belongs_to :hashy
end