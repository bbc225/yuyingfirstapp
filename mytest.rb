require 'sinatra'
require 'sinatra/base'
require 'slim'
require 'sass'



configure :production do
	require './song'
	DataMapper.setup(:default, ENV['DATABASE_URL'])
	enable :sessions
	set :username, 'frank'
	set :password, 'sinatra'
end

configure :development do
	require './song'
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
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

get '/songs/new' do
	halt(401,'Not Authorized') unless session[:admin]
	@song = Song.new
	slim :new_song
end

get '/songs/:id' do
	halt(401,'Not Authorized') unless session[:admin]
	@song = Song.get(params[:id])
	slim :show_song
end


post '/songs' do
	halt(401,'Not Authorized') unless session[:admin]
	song = Song.create(params[:song])
	redirect to("/songs/#{song.id}")
end

get '/songs/:id/edit' do
	halt(401,'Not Authorized') unless session[:admin]
	@song = Song.get(params[:id])
	slim :edit_song
end

put '/songs/:id' do
	halt(401,'Not Authorized') unless session[:admin]
	song = Song.get(params[:id])
	song.update(params[:song])
	redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do
	halt(401,'Not Authorized') unless session[:admin]
	Song.get(params[:id]).destroy
	redirect to('/songs')
end


