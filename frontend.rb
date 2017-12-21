require "unirest"
require "pp"

while true
  system "clear"
  puts "Choose an option"
  puts "[1] View all posts"
  puts "[2] Create a post"
  puts "[3] View one post"
  puts "[4] Update a post"
  puts "[5] Delete a post"
  puts
  puts "[signup] Signup"
  puts "[login] Login"
  puts "[logout] Logout"
  puts
  puts "[quit] Quit"
  input_option = gets.chomp
  if input_option == "1"
    response = Unirest.get("http://localhost:3000/v1/posts")
    pp response.body
  elsif input_option == "2"
    params = {}
    print "New post title: "
    params["title"] = gets.chomp
    print "New post body: "
    params["body"] = gets.chomp
    response = Unirest.post("http://localhost:3000/v1/posts", parameters: params)
    pp response.body
  elsif input_option == "3"
    print "Enter a post id: "
    id = gets.chomp
    response = Unirest.get("http://localhost:3000/v1/posts/#{id}")
    pp response.body
  elsif input_option == "4"
    print "Enter a post id: "
    id = gets.chomp
    response = Unirest.get("http://localhost:3000/v1/posts/#{id}")
    post = response.body
    params = {}
    print "Edit post title (#{post['title']}): "
    params["title"] = gets.chomp
    print "Edit post body (#{post['body']}): "
    params["body"] = gets.chomp
    params.delete_if { |_key, value| value.empty? }
    response = Unirest.patch("http://localhost:3000/v1/posts/#{id}", parameters: params)
    pp response.body
  elsif input_option == "5"
    print "Enter a post id: "
    id = gets.chomp
    response = Unirest.delete("http://localhost:3000/v1/posts/#{id}")
    pp response.body
  elsif input_option == "signup"
    print "Enter name: "
    input_name = gets.chomp
    print "Enter email: "
    input_email = gets.chomp
    print "Enter password: "
    input_password = gets.chomp
    print "Confirm password: "
    input_password_confirmation = gets.chomp
    response = Unirest.post(
      "http://localhost:3000/v1/users",
      parameters: {
        name: input_name,
        email: input_email,
        password: input_password,
        password_confirmation: input_password_confirmation
      }
    )
    pp response.body
  elsif input_option == "login"
    print "Enter email: "
    input_email = gets.chomp
    print "Enter password: "
    input_password = gets.chomp
    response = Unirest.post(
      "http://localhost:3000/user_token",
      parameters: {
        auth: {
          email: input_email,
          password: input_password
        }
      }
    )
    jwt = response.body["jwt"]
    Unirest.default_header("Authorization", "Bearer #{jwt}")
    pp response.body
  elsif input_option == "logout"
    jwt = ""
    Unirest.clear_default_headers()
    puts "Logged out successfully!"
  elsif input_option == "quit"
    puts "Goodbye!"
    break
  else
    puts "Unknown option."
  end
  puts "Press enter to continue."
  gets.chomp
end
