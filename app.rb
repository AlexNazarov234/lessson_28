#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'CREATE TABLE if not exists Posts 
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT, 
		created_date DATE, 
		content TEXT
	)'

	@db.execute 'CREATE TABLE if not exists Comments 
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT, 
		created_date DATE, 
		content TEXT,
		post_id INTEGER
	)'
end

get '/' do
	@results = @db.execute 'select * from Posts order by id desc'

	erb :index
#	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]

  if content.length <= 0 
  	@error = 'Введите текст'
  	return erb :new
  end

  @db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content] 

  redirect to '/'
end

get '/details/:post_id' do
	post_id = params['post_id']

	results = @db.execute 'select * from Posts where id=?', [post_id]
	@row = results[0]

	erb :details
end


post '/details/:post_id' do
	post_id = params['post_id']
  content = params[:content]

	erb "comment #{content} to #{post_id}"	
end