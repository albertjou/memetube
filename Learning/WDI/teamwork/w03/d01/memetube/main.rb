require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'

#home page for the web app
get '/' do
  #get all the videos
  @videos = connect("SELECT * FROM videos")
  @videos = @videos.map {|hash| hash}
  @genres = @videos.map {|x| x["genre"].to_s}
  #link to the index page
  erb :index
end


get '/videos/new' do
  erb :form
end

post '/videos/create' do
  query = "INSERT INTO videos (title, url, genre) VALUES ('#{params[:video_name]}', '#{params["url"].split('/')[-1]}', '#{params[:genre]}')"
  connect(query)
  #binding.pry
  redirect to '/'
end

get '/videos/:id' do
  @video = connect("SELECT * FROM videos WHERE id=#{params[:id]}")
  @video = @video.first

  if @video.nil?
    redirect to '/'
  end
  erb :videoview
end

get'/videos/:id/delete' do
  @video = connect("DELETE FROM videos WHERE id=#{params[:id]}")
  redirect to '/'
end


get '/videos/:id/edit' do
  @video = connect("SELECT * FROM videos WHERE id=#{params[:id]}")
  @video = @video.first
  erb :edit
end

post '/videos/update' do
  query = "UPDATE videos SET title='#{params[:title].gsub(/'/, "\'")}', url='#{params[:url].split('/')[-1]}', genre='#{params[:genre]}' WHERE id=#{params[:id]}"
  connect(query)
  redirect to "/videos/#{params[:id]}"

end

get '/genre/:genre' do
  @videos = connect("SELECT * FROM videos")
  @genres = @videos.map {|x| x["genre"].to_s}
  @list = @videos.map {|hash| hash}
  new_list = []
  @list.map {|x|
    if x.has_value?(params[:genre].to_s.gsub("+"," "))
      new_list << x
    end
  }
  @videos = new_list
  erb :index
end

def connect(query)
    connection = PG.connect(:dbname => 'memetube', :host => 'localhost')
    result = connection.exec(query)
    connection.close
    result
end
