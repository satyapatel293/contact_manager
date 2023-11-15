require "pg"

class DatabasePersistence
  def initialize
    @db = PG.connect(dbname: "contacts_project")
  end 

  def load_all_contacts
    @result = @db.exec("SELECT c.*, ca.category_name FROM contacts AS c JOIN categories AS ca ON c.category_id = ca.id ")
    @result.map do |tuple| 
      { id: tuple["id"], 
        name: tuple["name"],
        phone_number: tuple["phone_number"],
        email: tuple["email"],
        category_name: tuple["category_name"],
      }
    end 
  end 

  def load_contact_info(contact_id)
    sql = "SELECT * FROM contacts WHERE id = $1"
    @result = @db.exec_params(sql, [contact_id])

    @result.map do |tuple|
      { id: tuple["id"], 
        name: tuple["name"],
        phone_number: tuple["phone_number"],
        email: tuple["email"],
        category_id: tuple["category_id"] }
    end.first 
  end 

  def add_contact(name, phone, email)
    sql = "INSERT INTO contacts (name, phone_number, email) VALUES ($1, $2, $3);"
    @db.exec_params(sql, [name, phone, email])
  end 

  def update_contact_information(id, name, phone, email)
    sql = "UPDATE contacts SET name = $1, phone_number = $2, email = $3 WHERE id = $4"
    @db.exec_params(sql, [name, phone, email, id])
  end 

  def delete_contact(id)
    sql = "DELETE FROM contacts WHERE id = $1"
    @db.exec_params(sql, [id])
  end 
end 