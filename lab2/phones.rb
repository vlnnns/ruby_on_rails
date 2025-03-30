require 'json'

contacts = []

def add_contact(contacts)
  print "Name: "
  name = gets.chomp
  print "Phone: "
  phone = gets.chomp
  contacts << { name: name, phone: phone }
end

def list_contacts(contacts)
  if contacts.empty?
    puts "No contacts found"
  else
    contacts.each_with_index do |c, i|
      puts "#{i + 1}. #{c[:name]} — #{c[:phone]}"
    end
  end
end

def edit_contact(contacts)
  list_contacts(contacts)
  print "Enter the number of the contact to edit: "
  index = gets.to_i - 1
  if contact = contacts[index]
    print "New name: "
    name = gets.chomp
    print "New phone: "
    phone = gets.chomp
    contact[:name] = name unless name.empty?
    contact[:phone] = phone unless phone.empty?
  else
    puts "Contact not found"
  end
end

def delete_contact(contacts)
  list_contacts(contacts)
  print "Enter the number of the contact to delete: "
  index = gets.to_i - 1
  if contacts[index]
    contacts.delete_at(index)
    puts "Contact deleted"
  else
    puts "Contact not found"
  end
end

def save_contacts(contacts)
  File.write("contacts.json", JSON.pretty_generate(contacts))
  puts "Contacts saved to contacts.json"
end

def load_contacts
  if File.exist?("contacts.json")
    JSON.parse(File.read("contacts.json"), symbolize_names: true)
  else
    []
  end
end

contacts = load_contacts

loop do
  puts "\n--- Phone Book ---"
  puts "1. View contacts"
  puts "2. Add contact"
  puts "3. Edit contact"
  puts "4. Delete contact"
  puts "5. Save contacts"
  puts "6. Exit"
  print "Choose an option: "

  case gets.to_i
  when 1 then list_contacts(contacts)
  when 2 then add_contact(contacts)
  when 3 then edit_contact(contacts)
  when 4 then delete_contact(contacts)
  when 5 then save_contacts(contacts)
  when 6
    puts "Goodbye!"
    break
  else
    puts "Invalid choice"
  end
end
