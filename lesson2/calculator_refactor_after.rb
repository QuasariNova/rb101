# Now that I Watched the video on refactoring their code, I want to revisit the
# code I made prior to the first video and see if I can improve it to a similar
# functionality as what their calculator has become

# In the video, the operation_to_message method is dangerous because it assumes
# the case statement is the last expression and someone might want to expand
# the method in the future. To get around this, you can store the result of the
# case statement and implicitly return this at the end to keep the method
# working with the problem. This would be the same for my calculate method.
def calculate(operator, numbers)
  case operator
  when '*' then numbers[0] * numbers[1]
  when '+' then numbers[0] + numbers[1]
  when '-' then numbers[0] - numbers[1]
  when '/'
    return 'ERROR' if numbers[1].zero?
    numbers[0] / numbers[1].to_f
  end
end

# video used a predicate, but I'd rather conver to both float/int so it's not
# as easy to validate with a true or false. This takes a string and checks if
# it is a float or an integer and returns either, else it returns nil meaning
# the string is not a valid number. The things to think about section asks if
# there is a better way to validate the input. I use converting the input to a
# number then check if it converts back to the same string. It would be even
# better to run a regular expression, but I'm not too familiar with how to do
# that yet.
def validate_input(input)
  value = nil
  value = input.to_i if input.to_i.to_s == input
  value = input.to_f if input.to_f.to_s == input
  value
end

def prompt(message)
  puts "=> #{message}"
end

name = ''
loop do
  prompt "Welcome to CALCULATOR! What is your name?"

  name = gets.chomp
  break unless name.empty?
  prompt "Please enter a valid name"
end

loop do
  numbers = %w('first' 'second').map do |n|
    loop do
      prompt "Enter #{n} number:"
      input = gets.chomp
      value = validate_input input
      break value if !value.nil?
      prompt "Please input a valid number"
    end
  end

  operator = loop do
    prompt 'Enter operator(+, -, *, or /):'
    input = gets
    char = input[0]
    break char if ['+', '-', '*', '/'].include?(char)

    prompt 'Please enter either +, -, *, or /'
  end

  prompt "#{numbers[0]} #{operator} #{numbers[1]} = " +
         "#{calculate(operator, numbers)}"

  prompt "Would you like to calculate again? (y/n)"
  break unless gets.downcase.start_with? 'y'
end

prompt "Goodbye, #{name}"

# The Things to think about section asks if we could move the messages into
# some configuration file and access by key. If I knew IO we could use
# something like an xml or json file to store key value pairs and import it
# back in as a hash, using the hash and key to recall the messages. This could
# be used to make use of multiple translations allowing one program to work in
# many regions.
