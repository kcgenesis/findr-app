require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:my_webapp_database.sqlite3"

require './models'

set :sessions, true

get '/' do 
	if current_user
		redirect '/user'
	else
		erb :home
	end
end

get '/signin' do
	erb :signin
end

post '/signin' do
	@signin = params[:in]
	@signup = params[:up]
	puts "my params are"+params.inspect
	if @signin.nil?
		#work with signup
		@checks=false
		@mm = 		@signup[4]
		@dd = 		@signup[5]
		@yyyy = 	@signup[6]
		@pw = 		@signup[7]
		@pw2 = 		@signup[8]		#test validation with pw using javaScript

		@verified = (@pw == @pw2)
		if @verified
			@user = User.create(
				username: 	@signup[0],
				password: 	@signup[1], 
				email: 		@signup[2], 
				fname: 		@signup[3], 
				lname: 		@lname, 
				birthday: 	Time.parse("#{@yyyy}-#{@mm}-#{@dd} 00:00:00 0000"), 
				created_at: Time.now, 
				updated_at: Time.now,
			)
			@checks=true
		else
			puts "passwords don't match"
		end
	else
		#work with signin
		@checks=false
		@un = @signin[0]
		@pw = @signin[1]
		#find users with the same name.
		@matches = User.where(username: @un)
		#if there are USERNAME matches
		#checks for PASSWORD matches within these
		if @matches 
			@matches.each do |m|
				puts "checking #{m} pw matched!!!"
				#if NO matches encountered thus far 
				#AND match password = password
				if m.password == @pw
					@checks = true
					@user = m
				end
			end
		#if there are no matches
		else
			puts "no matches"
		end
	end
	#if the user creates their account successfully
	#OR if the user logs into their account successfully
	if @checks == true
		# log in the user by setting the session[:user_id] to their ID
		session[:user_id] = @user.id
		redirect '/user'
	else
		@checks = false
		@verified = false
		redirect '/signin'
	end
end


#user page
get '/user' do
	@user = current_user
	if @user
		erb :user
	else
		erb :home
	end
end

get '/upload' do
	@user = current_user
	@pics = Post.where(user_id: @user.id)
	erb :upload
end

get '/logout' do
	session[:user_id] = nil
	redirect '/signin'
end

post '/upload' do 

	def popout string,regex
		gruppe = string.split("")
		gruppe.each_with_index do |thing,index|
			if regex.match("#{thing}")
				puts "REMOVING #{index}"
				gruppe[index] = ""
			end
		end
		string = gruppe.join("")
		return string	
	end

	puts "\n\n\nupload in progress\n\n\n"
	@user= current_user
	#replace spaces
	@nam = params[:myfile][:filename]
	@nam = @nam.split(" ")
	@nam = @nam.join("_")
	puts "\n\n\npublic/"+"#{@nam} is the save path\n\n\n"
	File.open('public/' + @nam, "w") do |f|
		f.write(params[:myfile][:tempfile].read)
	end

	@post = Post.create(
		caption: params[:mycaption],
		location: "Queens, NY",
		image_url: @nam,
		user_id: @user.id,
		created_at: Time.now,
		updated_at: Time.now
		)

	@hashes = params[:myhashes].to_s
	puts "\n\nHASHTAG STRING: #{@hashes}\n\n"
	#separate the string by the hashtags
	@group = @hashes.split("#")
	puts "\n\nHASHTAG STRING SPLIT: #{@group.inspect}\n\n"
	#for each hash
	@group.each do |word|
		word = popout(word,/[^A-Za-z\d]/).downcase
		#work with this word.
		#if it matches something in the the hashtag database
		#and has nonzero length
		if word.length != 0
			@match = Hashy.where(word: word).first
			if @match
				#add the current post ID to this hash
				PostHashy.create(post_id: @post.id,hash_id: @match.id)
				#update
				@match.updated_at = Time.now
				puts "\n\n\nhashtag #{@match} updated\n\n\n"
			else #if this is a new hash
				#then create it
				@hashy = Hashy.create(
					word: word,
					post_id: @post.id,
					created_at: Time.now,
					updated_at: Time.now
		  		)
		  		PostHashy.create(post_id: @post.id,hash_id: @hashy.id)
		  		puts "\n\n\nhashtag ##{@hashy.word} created\n\n\n"			
			end
		end
	end
	
  @pic = 'public/' + params[:myfile][:filename]
  redirect "/upload"
  return "The file was successfully uploaded!"

end

get '/pic/:id' do
	@post = Post.find(params[:id])
	@caption = @post.caption
	if @post
		erb :pic
	else
		redirect '/'
	end
end

get '/tag/:id' do
	@hashy = Hashy.find(params[:id])
	if @hashy
		erb :tag
	else
		redirect '/'
	end
end



def current_user
	if session[:user_id]
		puts "session found"
		@current_user = User.find(session[:user_id])
	else
		puts "idk where the session is"
	end
end


