# encoding: utf-8

require "json"
require "mongoid"
require "sinatra"
require "sinatra/base"

require "sinatra/json"
require "sinatra/cookies"

require "./model/cookie"
require "./model/map_object"
require "./model/hut"
require "./model/nonce"
require "./model/shelter"
require "./model/user"

require "./helpers/cookie_helpers"
require "./helpers/login_helpers"
require "./helpers/nonce_helpers"
require "./helpers/rest_helpers"
require "./helpers/view/object_presentation_helpers"

Mongoid.load!("mongoid.yml")

CookieHelpers.add
LoginHelpers.add
NonceHelpers.add
RestHelpers.add
ObjectPresentationHelpers.add

helpers Sinatra::JSON
helpers Sinatra::Cookies

before %r{/rest/([\w]+)} do
  nonce = params["nonce"]
  halt 403 unless nonce_valid?(nonce)
end

get '/' do
  erb :index, :layout=>:mainlayout
end

get '/endpoints.js' do
  content_type "application/javascript"
  erb :"endpoints.js"
end

get '/map/' do
  erb :map, :layout => :mainlayout
end

get '/list/' do
  erb :list, :layout => :mainlayout, :locals => {:objects => MapObject.where({})}
end

get '/list/:term' do
  term = params[:term].downcase

  objects = MapObject.where({}).select { |object|
      object.name.downcase.index(term) != nil
  }

  erb :list, :layout => :mainlayout, :locals => {:objects => objects}
end

get '/contact/' do
  erb :contact, :layout => :mainlayout
end

get '/edit/:id' do
  require_login
  id = params[:id]
  halt 404 unless id and id.length > 0
  result = MapObject.where({id: id})
  halt 404 unless result.length > 0
  erb :edit_object, :layout => :mainlayout, :locals => {:object => result[0]}
end

get '/add/' do
  require_login
  erb :edit_object, :layout => :mainlayout
end

get '/rest/objects/names/' do
  result = MapObject.where({}).map { |object|
    object.name
  }
  json result.sort
end

put '/rest/objects/new' do
  hash = JSON.parse(request.body.string)
  MapObject.create(hash)
end

post '/rest/login' do
  hash = JSON.parse(request.body.string)
  email = hash["email"] || ""
  password = hash["password"] || ""

  # Return 401 if username and emails are invalid.
  halt 401 unless email.length > 0 and password.length > 0

  halt 401 unless User.where({email: email, password: password}).length > 0

  # Set the login cookie.
  cookie_data = get_cookie()
  cookies[:huts_login] = cookie_data

  # Old browser cookie support.
  headers \
    "Access-Control-Allow-Credentials" => "true"

  # Return empty body. TODO: Return user object.
  ""
end

post '/rest/logout' do
  if cookies[:huts_login] != nil
    data = cookies[:huts_login]
    cookies.delete(:huts_login)
    # remove it from DB
    remove_cookie(data)
  end

  # Empty body. Leave it to avoid errors...
  ""
end

get '/rest/objects/all/' do
  # XXX: use helper
  MapObject.where({}).map {|doc| result = doc.as_document}.to_json
end

post '/rest/edit/:id' do
  require_login
  object_data = JSON.parse(request.body.string)

  result = MapObject.where({id: params[:id]})
  halt 404 unless result.length > 0

  target_object = result[0]
  target_object.lat = object_data["lat"]
  target_object.name = object_data["name"]
  target_object.lng = object_data["lng"]
  target_object.alt = object_data["alt"]
  target_object.description = object_data["description"]
  target_object.save!
end

put '/rest/add/' do
  require_login
  object_data = JSON.parse(request.body.string)

  p object_data["type"]
  type = case object_data["type"]
           when "shelter" then Shelter
           when "hut" then Hut
           else MapObject
         end

  target_object = type.create()
  target_object.lat = object_data["lat"]
  target_object.name = object_data["name"]
  target_object.lng = object_data["lng"]
  target_object.alt = object_data["alt"]
  target_object.description = object_data["description"]
  target_object.save!

  ""
end

delete '/rest/delete/:id' do
  require_login

  result = MapObject.where({id: params[:id]})
  halt 404 unless result.length > 0
  result.delete_all

  ""
end
