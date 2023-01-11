# As you program more, you'll start to realize that there's no such thing as a
# program that's "done". Here are a few bonus features you can tackle if you're
# up for it. They're optional, so if you're in a rush, you don't have to do
# them.
#
#   Better integer validation.
#
#   The current method of validating the input for a number is very weak. It's
#   also not fully accurate, as you cannot enter a 0. Come up with a better way
#   of validating input for integers.
# 
#
# Number validation.
#
#
# Suppose we're building a scientific calculator, and we now need to account
# for inputs that include decimals. How can we build a validating method,
# called number?, to verify that only valid numbers -- integers or floats --
# are entered?
#
# Our operation_to_message method is a little dangerous, since we're relying on
# the case statement being the last expression in the method. Suppose we needed
# to add some code after the case statement within the method? What changes
# would be needed to keep the method working with the rest of the program?
#
# Extracting messages in the program to a configuration file.
#
# There are lots of messages sprinkled throughout the program. Could we move
# them into some configuration file and access by key? This would allow us to
# manage the messages much easier, and we could even internationalize the
# messages.
#
# Your calculator program is a hit, and it's being used all over the world!
# Problem is, not everyone speaks English. You need to now internationalize the
# messages in your calculator. You've already done the hard work of extracting
# all the messages to a configuration file. Now, all you have to do is send
# that configuration file to translators and call the right translation in your
# code.
#
# Hopefully you've enjoyed the excursions into building these interesting
# features. The goal here isn't to overwhelm you, but to let you see how
# various seemingly complicated features are built up piece by piece. Don't
# worry about mastering regex, or file processing, or internationalizing your
# programs. This assignment is to just show you how you can use various pieces
# of your knowledge to build useful features, and how seemingly complicated
# features are just pieced together bit by bit.

# ------------------------------------------------------------------------------

# I have already done a lot of this, when I refactored after the video, but
# let's get em all implemented!

# Extracting messages in the program to a configuration file.

# There are lots of messages sprinkled throughout the program. Could we move 
# them into some configuration file and access by key? This would allow us to 
# manage the messages much easier, and we could even internationalize the 
# messages.
require 'yaml'
MESSAGES = YAML.load_file("calculator_assignment.yaml")

# Your calculator program is a hit, and it's being used all over the world!
# Problem is, not everyone speaks English. You need to now internationalize the
# messages in your calculator. You've already done the hard work of extracting
# all the messages to a configuration file. Now, all you have to do is send
# that configuration file to translators and call the right translation in your
# code.
# -----
# The only realy change is the language being added as a higher key and our
# method specificly loading one for a language.
def get_message(message, language='en')
  MESSAGES[language][message]
end

# Our operation_to_message method is a little dangerous, since we're relying on
# the case statement being the last expression in the method. Suppose we needed
# to add some code after the case statement within the method? What changes
# would be needed to keep the method working with the rest of the program?
# ----
# I don't use their operation_to_message, as my input is the operator and it's
# easy to just push it into the string. However, I do use this method for the
# calculation and it does implicitly return the results of a case statement.
def calculate(operator, numbers)
  result = case operator
           when '*' then numbers[0] * numbers[1]
           when '+' then numbers[0] + numbers[1]
           when '-' then numbers[0] - numbers[1]
           when '/'
             return 'ERROR' if numbers[1].zero?
             numbers[0] / numbers[1].to_f
  end
  result
end

# The current method of validating the input for a number is very weak. It's
# also not fully accurate, as you cannot enter a 0. Come up with a better way
# of validating input for integers.
# -----
# I already solved this prior to this assignment, I convert the input to a
# number, then back into a string and compare with the original string, if they
# match they are definitely a number. 
def validate_input(input)
  value = nil
  value = input.to_i if input.to_i.to_s == input
  value = input.to_f if input.to_f.to_s == input
  value
end

# Suppose we're building a scientific calculator, and we now need to account
# for inputs that include decimals. How can we build a validating method,
# called number?, to verify that only valid numbers -- integers or floats --
# are entered?
# ----
# I again kind of already did this with validate_input method. My solution 
# converts as well as validating, but here's that method as they described. 
# Apparently my method has an edge case, but I don't know regex, so this is 
# best I can do right now. 
def number?(input)
  input.to_i.to_s == input || input.to_f.to_s == input
end

def prompt(message)
  puts "=> #{message}"
end

name = ''
loop do
  prompt get_message('greeting')

  name = gets.chomp
  break unless name.empty?
  prompt get_message('name_error')
end

loop do
  numbers = [get_message('first'), get_message('second')].map do |n|
    loop do
      prompt n
      input = gets.chomp
      value = validate_input input
      break value if !value.nil?
      prompt get_message('number_error')
    end
  end

  operator = loop do
    prompt get_message('operator')
    input = gets
    char = input[0]
    break char if ['+', '-', '*', '/'].include?(char)

    prompt get_message('operator_error')
  end

  prompt "#{numbers[0]} #{operator} #{numbers[1]} = " +
         "#{calculate(operator, numbers)}"

  prompt get_message('again')
  break unless gets.downcase.start_with? 'y'
end

prompt "#{get_message('farewell')} #{name}"
