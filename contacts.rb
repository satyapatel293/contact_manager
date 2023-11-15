require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"

require_relative "database_persistence"

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
end 

configure :development do 
  require "sinatra/reloader" 
  also_reload "database_persistence.rb"
end 

helpers do 
  def sort_contacts(contact_list)
    contact_list.sort_by {|contact| contact[:name]}
  end   

  def sort_by_category(contact_list)
    contact_list.chunk do |contact| 
      contact[:category_name]
    end
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

get "/categories" do 
  @contacts = @storage.load_all_contacts
  @list = sort_by_category(@contacts)
  erb :categories, layout: :layout
end 
# Display new contact form
get "/contact/new" do 
  erb :new_contact, layout: :layout
end 


def error_for_phone_number_formating(phone_number)
  formated = phone_number.gsub(/-|\s|\(|\)/, "").match?(/^\d{10}$/)
  "Please format phone number like so ###-###-####" unless formated
end 

def error_for_email_formating(email)

end 

# TODO redirect to new contact (need method to find id)
# Create new contact 
post "/contact" do 
  error = error_for_phone_number_formating(params[:phone_number])
  if error 
    session[:error] = error 
    erb :new_contact, layout: :layout
  else 
    @storage.add_contact(params[:name], params[:phone_number], params[:email])
    session[:success] = "Contact Added!"
    redirect  "/contacts"
  end 
end   

# Display a singluar contacts information with update/delete links
get "/contact/:id" do 
  @contact = @storage.load_contact_info(params[:id].to_i)
  erb :contact, layout: :layout
end 

# Display update page 
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

  error = error_for_phone_number_formating(@new_phone_number)
  if error 
    session[:error] = error 
    @contact = { name: @new_name, 
                 phone_number: @new_phone_number, 
                 email: @new_email }
    erb :update_contact, layout: :layout
  else 
    @storage.update_contact_information(id, @new_name, @new_phone_number, @new_email)
    session[:success] = "Contact Updated!"
    redirect "/contact/#{id}"
  end 
end 

post "/contact/:id/destroy" do 
  @storage.delete_contact(params[:id])
  redirect "/contacts"
end 

