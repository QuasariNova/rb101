# This is for Assignment: RPS Bonus Features. It asks to change the RPS
# walkthrough program to facilitate the game Rock Paper Scissors Lizard Spock.
# It also asks for you to be able to not have to type out the whole action in
# order to use said action.
# Finally, it asks you to keep score and crown a grand winner if a player gets
# 3+ wins

require 'io/console'

VALID_CHOICES = %w(rock paper scissors spock lizard)

def prompt(message='', print_it: false)
  string = "=> #{message}"
  if print_it
    print string
  else
    puts string
  end
end

# Returns -1 for player 2 win, 1 for player 1 win, and 0 for tie
def calculate_win(player_one_choice, player_two_choice)
  one_index = VALID_CHOICES.index(player_one_choice)
  two_index = VALID_CHOICES.index(player_two_choice)
  index_dif = one_index - two_index
  return 0 if index_dif.zero?
  # This only works if VALID_CHOICES is set up right and is an odd length
  return 1 if (index_dif % VALID_CHOICES.length).odd?
  -1
end

def display_score(score)
  prompt "Player: #{score[0]}     Computer: #{score[1]}"
end

def find_possible_inputs(user_input)
  VALID_CHOICES.select { |choice| choice.start_with? user_input }
end

def display_results(who_won)
  prompt case who_won
         when -1 then "The Computer Won!"
         when 0 then "It's a tie"
         when 1 then "You won!"
         end
end

def ask_to_replay
  loop do
    prompt "Would you like to play again? (y/n)"
    prompt(print_it: true)
    again = gets.downcase
    break true if again.start_with? 'y'
    break false if again.start_with? 'n'
    prompt "Please enter y/es or n/o!"
  end
end

def print_menu(choices)
  prompt "Choose an option(1-#{choices.length})"
  choices.each_with_index do |choice, index|
    prompt "#{index + 1} #{choice.capitalize}"
  end
end

def ask_to_pick_number_menu(choices)
  print_menu choices
  loop do
    prompt(print_it: true)
    choice = gets
    index = choice.to_i - 1
    break index unless index < 0 || index >= choices.length
    prompt "Please pick a number between 1-#{choices.length}"
  end
end

loop do
  $stdout.clear_screen
  prompt "Welcome to Rock, Paper, Scissors, Lizard Spock."

  menu_prompts = ["Play Quick Game", "Play Match(first to 3)", "Quit"]
  title_choice = ask_to_pick_number_menu menu_prompts

  break if title_choice == 2
  match = title_choice == 1
  score = [0, 0]

  loop do # game loop
    $stdout.clear_screen
    display_score score if match

    player_one_choice = loop do # input loop
      prompt "Rock, Paper, Scissors, Lizard, or Spock?"

      prompt print_it: true
      choices = find_possible_inputs gets().chomp().downcase()

      break choices[0] if choices.length == 1

      if choices.length > 1
        prompt "Did you mean:"
        menu_prompts = choices + ["None of the above."]
        further_choice = ask_to_pick_number_menu menu_prompts

        next if further_choice == menu_prompts.length - 1
        break choices[further_choice]
      end # end of verification check

      prompt "Please enter a valid choice!"
    end # end of player choice loop

    player_two_choice = VALID_CHOICES.sample

    $stdout.clear_screen

    prompt <<~TXT.chomp
      You played #{player_one_choice}; Computer played #{player_two_choice}
    TXT

    who_won = calculate_win(player_one_choice, player_two_choice)
    display_results who_won

    if !match
      again = ask_to_replay
      if again
        next
      else
        break
      end
    end

    index = (1 - who_won) / 2
    score[index] += 1 if !who_won.zero?
    display_score score

    if score[index] >= 3
      prompt "#{index.zero? ? 'You are' : 'The computer is'} the Grand Winner!"
      again = ask_to_replay
      if again
        next
      else
        break
      end
    end

    prompt "Press any key to continue"
    $stdin.getch
  end
end
prompt "Goodbye! Thanks for playing!"
