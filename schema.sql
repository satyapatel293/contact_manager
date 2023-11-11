CREATE TABLE categories (
  id serial PRIMARY KEY,
  name text NOT NULL 
);

CREATE TABLE contacts (
  id serial PRIMARY KEY,
  name text NOT NULL,
  phone_number text NOT NULL, 
  email text NOT NULL,
  category_id int REFERENCES categories (id) 
);

INSERT INTO categories (name) 
VALUES ('Family'), ('Friends'), ('Coworkers');

INSERT INTO contacts (name, phone_number, email, category_id)
VALUES 
('Janki Patel', '5516893949', 'janki792@gmail.com', 1),
('Heta Patel', '2019125353', 'heta110@gmail.com', 1),
('Meena Patel', '5515800110', 'meena627@yahoo.com', 1),
('Bob Smith', '2017952194', 'bobys@hotmail.com', 3),
('Quan Bo', '5512262815', 'bothai@gmail.com', 2),
('Manan Patel', '5512255221', 'manan@kuhsifoods.org', 2),
('AT&T', '201112233', 'customers@att.net', null);