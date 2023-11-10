require "sinatra"
require "sinatra/content_for"
require "sinatra/reloader" 
require "tilt/erubis"

# configure do
#   enable :sessions
#   set :session_secret, SecureRandom.hex(32)
#   set :erb
# end 

get "/" do 
  erb :main
end 

class List
  def initialize
    @storage = []
  end 
  
  def view_contacts 
    @storage.each {|contact| puts contact; puts "\n ---------"}
  end 

  def add_contact
    @storage << Contact.new
  end 

  def delete_contact(name)
    contact_to_delete = @storage.select do |contact|
      contact.name == name 
    end.first

    @storage.delete(contact_to_delete)
    puts contact_to_delete.name + " has been deleted"
  end 
end


class Contact
  attr_accessor :name

  def initialize 
    create_contact
  end 

  def create_contact
    puts "Name:"
    @name = gets.chomp 
    puts "Phone Number:"
    @number = gets.chomp 
    puts "email:"
    @email = gets.chomp  
  end 

  def to_s
    "Name: #{@name}\nPhone Number:#{@number}\nEmail:#{@email}"
  end 
end 
