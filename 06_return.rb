def build_greeting(name)
  if name == "Landon"
    "Hey, it's you!"
  else
    "Hello, #{name}!"
  end
end

message = build_greeting("Landon")
puts message

message2 = build_greeting("NotLandon")
puts message2

