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
		@un  = 		@signup[0]
		@email = 	@signup[1]
		@fname = 	@signup[2]
		@lname = 	@signup[3]
		@mm = 		@signup[4]
		@dd = 		@signup[5]
		@yyyy = 	@signup[6]
		@pw = 		@signup[7]
		@pw2 = 		@signup[8]		#test validation with pw using javaScript
		@verified = (@pw == @pw2)
		if @verified
			@user = User.create(
				username: 	@un,
				password: 	@pw, 
				email: 		@email, 
				fname: 		@fname, 
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


get '/logout' do
	session[:user_id] = nil
	redirect '/signin'
end

def current_user
	if session[:user_id]
		puts "session found"
		@current_user = User.find(session[:user_id])
	else
		puts "idk where the session is"
	end
end

