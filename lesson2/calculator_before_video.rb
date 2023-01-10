# From Lesson 2: 6 Walk-through: Calculator
# Build a command line calculator program that does the following:
#
#     asks for two numbers
#     asks for the type of operation to perform: add, subtract, multiply or
#     divide
#     displays the result
#
# Use the Kernel.gets() method to retrieve user input, and use Kernel.puts()
# method to display output. Remember that Kernel.gets() includes the newline,
# so you have to call chomp() to remove it: Kernel.gets().chomp().
#
# This is my solution before doing the walkthrough video. I wanted to see what
# I could do first, before seeing how Launch School was going to teach me how
# to do it. I did not use Kernel.gets().chomp() as I didn't need it.

def calculate(operator, numbers)
  case operator
  when '*' then numbers[0] * numbers[1]
  when '+' then numbers[0] + numbers[1]
  when '-' then numbers[0] - numbers[1]
  when '/'
    return puts "Divide By Zero Error" if numbers[1].zero?
    numbers[0] / numbers[1]
  else
    nil
  end
end

numbers = [1, 2].map do |n|
  puts "Enter number #{n}:" # might do a ternary for 'first' or 'second'
  input = gets
  input.to_i == input.to_f ? input.to_i : input.to_f
end

operator = loop do
             puts "Enter operator(+, -, *, or /):"
             input = gets
             char = input[0]
             break char if char == '+' || char == '-' || char == '*' || 
                           char == '/'
             puts "Please enter either +, -, *, or /"
           end

puts "#{numbers[0]} #{operator} #{numbers[1]} = #{calculate(operator, numbers)}"
