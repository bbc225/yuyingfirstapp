require 'sinatra'
require 'slim'
require 'sass'
require 'mysql2'
require 'active_record'

ActiveRecord::Base.establish_connection ({
  :adapter => "mysql2",
  :host => "localhost",
  :username => "root",
  :password => "bbc123456",
  :database => "mytest"})

class Song < ActiveRecord::Base 
	#validates :name, presence: true
	self.table_name = "Song"
end