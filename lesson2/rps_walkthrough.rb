VALID_CHOICES = %w(rock paper scissors)

def test_method
  prompt('test message')
end

def prompt(message)
  puts "=> #{message}"
end

test_method

# I rewrote that jumbled if statement to this, though if we add more choices,
# this will need to change
# 1 is player wins, 0 is computer wins, -1 is draw
def calculate_win(player_choice, computer_choice)
  pc = VALID_CHOICES.index player_choice
  ec = VALID_CHOICES.index computer_choice
  ec += VALID_CHOICES.length if ec < pc
  ec - pc - 1
end

def display_results(who_won)
  case who_won
  when 1 then prompt "You won!"
  when 0 then prompt "Computer won!"
  when -1 then prompt "It's a tie!"
  end
end

loop do
  choice = ''

  loop do
    prompt "Choose one: #{VALID_CHOICES.join(', ')}"
    choice = gets.chomp

    break if VALID_CHOICES.include? choice
    prompt "That's not a valid choice."
  end

  computer_choice = VALID_CHOICES.sample

  prompt("You chose: #{choice}; Computer chose: #{computer_choice}")
  display_results calculate_win(choice, computer_choice)

  prompt "Do you want to play again?"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thank you for playing! Goodbye!"
