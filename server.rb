require "sinatra"
require "sinatra/activerecord"
require "pry"

set :views, File.join(File.dirname(__FILE__), "app/views")
require_relative "app/models/television_show"

get "/" do
  redirect "/television_shows"
end

get "/television_shows" do
  shows = TelevisionShow.all
  erb :index, locals: { shows: shows }
end

get "/television_shows/new" do
  show = TelevisionShow.new
  erb :new, locals: { show: show }
end

get "/television_shows/:id" do
  show = TelevisionShow.find(params[:id])
  erb :show, locals: { show: show }
end

post "/television_shows" do
  show = TelevisionShow.new(params[:television_show])
  if show.save
    redirect "/television_shows"
  else
    erb :new, locals: { show: show }
  end
end

get "/television_shows/:id/edit" do
  show = TelevisionShow.find(params[:id])
  erb :edit, locals: { show: show }
end

post "/television_shows/:id/edit" do |id|
  show = TelevisionShow.find_by(id: id)
  if show.update(params[:television_show])
    redirect "/television_shows/#{id}"
  else
    erb :edit, locals: { show: show }
  end
end
