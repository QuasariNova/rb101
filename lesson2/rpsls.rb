# This is for Assignment: RPS Bonus Features. It asks to change the RPS
# walkthrough program to facilitate the game Rock Paper Scissors Lizard Spock.
# It also asks for you to be able to not have to type out the whole action in
# order to use said action.
# Finally, it asks you to keep score and crown a grand winner if a player gets
# 3+ wins

require 'io/console'
require 'yaml'

VALID_CHOICES = %w(rock paper scissors spock lizard)
MESSAGES = YAML.load_file 'rpsls.yaml'

def get_message(message)
  MESSAGES[message]
end

def prompt(message='', print_it: false)
  string = "=> #{message}"
  if print_it
    print string
  else
    puts string
  end
end

# Returns -1 for player 2 win, 1 for player 1 win, and 0 for tie
# This only works if VALID_CHOICES is set up right and is an odd length
# Basically VALID_CHOICES is set that where every possible choice has the
# same win conditions in relation to each other. If it's +1 or +3 from
# another choice, it's a winner, +2 or +4 it's a loser. We take the modulus
# to turn negatives like -1 into positives like +4, while keeping positives
# the same.
def calculate_win(player_one_choice, player_two_choice)
  one_index = VALID_CHOICES.index(player_one_choice)
  two_index = VALID_CHOICES.index(player_two_choice)
  index_dif = one_index - two_index
  return 0 if index_dif.zero?
  return 1 if (index_dif % VALID_CHOICES.length).odd?
  -1
end

def display_score(score)
  player_score = get_message 'player_score'
  computer_score = get_message 'computer_score'

  prompt "#{player_score}#{score[0]}     #{computer_score}#{score[1]}"
end

def find_possible_inputs(user_input)
  VALID_CHOICES.select { |choice| choice.start_with? user_input }
end

def display_results(who_won)
  prompt case who_won
         when -1 then get_message 'computer_win'
         when 0 then get_message 'a_tie'
         when 1 then get_message 'player_win'
         end
end

def ask_to_replay
  loop do
    prompt get_message('play_again')
    prompt(print_it: true)

    again = gets.downcase
    break true if again.start_with? 'y'
    break false if again.start_with? 'n'

    prompt get_message('play_again_error')
  end
end

def print_menu(choices)
  option_message = get_message 'option'
  prompt "#{option_message} (1-#{choices.length})"

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

    prompt "#{get_message('number_error')} 1-#{choices.length}"
  end
end

def verify_player_intent(choices)
  return nil if choices.length == 0
  return choices[0] if choices.length == 1

  prompt get_message('verify_prompt')
  menu_prompts = choices + [get_message('verify_none')]

  intent = ask_to_pick_number_menu menu_prompts
  return nil if intent == menu_prompts.length - 1
  choices[intent]
end

def get_game_choice
  loop do
    prompt get_message('gameplay_prompt')

    prompt print_it: true
    choices = find_possible_inputs gets().chomp().downcase()

    intent = verify_player_intent choices
    break intent if intent

    prompt get_message('verify_error')
  end
end

def display_each_choices(player_one_choice, player_two_choice)
  player_played = get_message 'player_played'
  player_played += player_one_choice.capitalize

  computer_played = get_message 'computer_played'
  computer_played += player_two_choice.capitalize

  prompt "#{player_played};     #{computer_played}"
end

# start of game
loop do
  $stdout.clear_screen
  prompt get_message('welcome')

  menu_prompts = [get_message('play_quick'),
                  get_message('play_match'),
                  get_message('quit')]
  title_choice = ask_to_pick_number_menu menu_prompts

  break if title_choice == 2
  match = title_choice == 1
  score = [0, 0]

  loop do # game loop
    $stdout.clear_screen
    display_score score if match

    player_one_choice = get_game_choice

    player_two_choice = VALID_CHOICES.sample

    $stdout.clear_screen

    display_each_choices(player_one_choice, player_two_choice)

    who_won = calculate_win(player_one_choice, player_two_choice)
    display_results who_won

    index = (1 - who_won) / 2
    score[index] += 1 if !who_won.zero?
    display_score score if match

    if score[index] >= 3 || !match # game / match is over, check for play again
      if match
        prompt get_message(index.zero? ? 'player_grand' : 'computer_grand')
      end
      again = ask_to_replay
      next if again
      break
    end

    prompt get_message('press_a_key')
    $stdin.getch
  end
end
prompt get_message('goodbye')
