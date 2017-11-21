require 'sinatra'
require 'sinatra/base'
require 'slim'
require 'sass'
require 'mysql2'
require 'active_record'


configure :production do
	require_relative './song'
	enable :sessions
	set :username, 'frank'
	set :password, 'sinatra'
	DataMapper.auto_migrate!
end

configure :development do
	require_relative 'mydata.rb'
	enable :sessions
	set :username, 'frank'
	set :password, 'sinatra'
end

get('/styles.css'){ scss :styles }

get '/login' do
	slim :login
end

post '/login' do
	if params[:username] == settings.username && params[:password] == settings.password
		session[:admin] = true
		redirect to('/songs')
	else
		slim :login
	end
end

get '/logout' do
	session.clear
	redirect to('/login')
end

get '/' do
	slim :home
end

get '/about' do
	@title = "All About This Website"
	slim :about
end
get '/contact' do
	slim :contact
end

not_found do
	slim :not_found
end


get '/songs' do
	@songs = Song.all
	slim :songs
end




