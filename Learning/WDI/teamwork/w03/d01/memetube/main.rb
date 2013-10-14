require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'

get '/' do
  @products = connect("SELECT * FROM products")
  erb :index

end

get '/products/new' do
  erb :form
end

post '/products/create' do
  query = "INSERT INTO products (name, description, price) VALUES ('#{params[:name].gsub(/'/, "\'")}', '#{params[:description].gsub(/'/, "\'")}', '#{params[:price]}')"
  connect(query)
  redirect to '/'
end

get '/products/:id' do
  @product = connect("SELECT * FROM products WHERE id=#{params[:id]}")
  @product = @product.first

  if @product.nil?
    redirect to '/'
  end
  erb :productview
end

get'/products/:id/delete' do
  @product = connect("DELETE FROM products WHERE id=#{params[:id]}")
  redirect to '/'
end


get '/products/:id/edit' do
  @product = connect("SELECT * FROM products WHERE id=#{params[:id]}")
  @product = @product.first
  erb :edit
end

post '/products/update' do
  query = "UPDATE products SET name='#{params[:name].gsub(/'/, "\'")}', description='#{params[:description].gsub(/'/, "\'")}', price='#{params[:price]}' WHERE id=#{params[:id]}"
  connect(query)
  redirect to "/products/#{params[:id]}"

end


def connect(query)
    connection = PG.connect(:dbname => 'wdistore', :host => 'localhost')
    result = connection.exec(query)
    connection.close
    result
end
