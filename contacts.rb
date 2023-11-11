require "sinatra"
require "sinatra/content_for"
require "sinatra/reloader" 
require "tilt/erubis"

require_relative "database_persistence"

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
end 

helpers do 
  def sort_contacts(contact_list)
    contact_list.sort_by {|contact| contact[:name]}
  end   
end 


before do 
  @storage = DatabasePersistence.new
end 


# Redirect to mainpage "/contacts"
get "/" do 
  redirect "/contacts" 
end 

# Displays list of all contacts with add contact link
get "/contacts" do 
  @contacts = @storage.load_all_contacts
  erb :index, layout: :layout
end 

get "/contact/new" do 
  erb :new_contact, layout: :layout
end 

# TODO redirect to new contact (need method to find id)
# Create new contact 
post "/contact" do 
  @storage.add_contact(params[:name], params[:phone_number], params[:email])
  redirect  "/contacts"
end   

# Display a singluar contacts information with update/delete links
get "/contact/:id" do 
  @contact = @storage.load_contact_info(params[:id].to_i)
  erb :contact, layout: :layout
end 

# TODO Display update page 
get "/contact/:id/update" do 
  @contact = @storage.load_contact_info(params[:id].to_i)
  erb :update_contact, layout: :layout
end 

# TODO Update a contact 
post "/contact/:id" do 
  id = params[:id].to_i
  @contact = @storage.load_contact_info(id)
  @new_name = params[:new_name]
  @new_phone_number = params[:new_phone_number]
  @new_email = params[:new_email]

  @storage.update_contact_information(id, @new_name, @new_phone_number, @new_email)
  redirect "/contact/#{id}"
end 

post "/contact/:id/destroy" do 
  @storage.delete_contact(params[:id])
  redirect "/contacts"
end 

