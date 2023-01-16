# This is a revised version of my Rock Paper Scissors Lizard Spock, using the
# feedback given from my code review. I am following through for practice and
# hopefully make the game better.

require 'io/console'
require 'yaml'

VALID_CHOICES = %w(rock paper scissors spock lizard)
MESSAGES = YAML.load_file 'rpsls_revised.yaml'
MATCH_WIN_LIMIT = 3 # Suggest to make game limit a constant for easier changes

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

# Returns :computer for player 2 win, :player for player 1 win, and 0 for tie
# Changed this because I'm changing scoring to a hash, this makes it a bit
# easier to read how scoring owrks as it doesn't require math to figure out the
# index.
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

  return nil if index_dif.zero?
  return :player if (index_dif % VALID_CHOICES.length).odd?
  :computer
end

def display_score(score)
  player_name = get_message 'player_name'
  computer_name = get_message 'computer_name'

  prompt <<~MESSAGE
    #{player_name}: #{score[:player]}     #{computer_name}: #{score[:computer]}
  MESSAGE
end

def find_possible_inputs(user_input)
  VALID_CHOICES.select { |choice| choice.start_with? user_input }
end

def display_game_results(who_won)
  return prompt get_message 'a_tie' if !who_won

  name_label = who_won == :player ? 'player_name' : 'computer_name'
  prompt format(get_message('actor_game_won'), name: get_message(name_label))
end

def display_match_results(who_won)
  grand_message = get_message 'actor_match_won'
  name_label = who_won == :player ? 'player_name' : 'computer_name'

  prompt format(grand_message, name: get_message(name_label))
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

def display_each_choices(p_one_choice, p_two_choice)
  played_message = get_message 'actor_played'

  player_played = format(played_message,
                         name: get_message('player_name'),
                         action: p_one_choice.capitalize)

  computer_played = format(played_message,
                           name: get_message('computer_name'),
                           action: p_two_choice.capitalize)

  prompt "#{player_played};     #{computer_played}"
end

def create_zero_score
  Hash.new(0)
end

# start of game
loop do
  $stdout.clear_screen
  prompt get_message('welcome')

  menu_prompts = [get_message('play_quick'),
                  format(get_message('play_match'), limit: MATCH_WIN_LIMIT),
                  get_message('quit')]
  title_choice = ask_to_pick_number_menu menu_prompts

  break if title_choice == 2
  match = title_choice == 1

  score = create_zero_score

  loop do # game loop
    $stdout.clear_screen
    display_score score if match

    player_one_choice = get_game_choice

    player_two_choice = VALID_CHOICES.sample

    $stdout.clear_screen

    display_each_choices(player_one_choice, player_two_choice)

    who_won = calculate_win(player_one_choice, player_two_choice)
    display_game_results who_won

    score[who_won] += 1 unless !who_won # this is easier to understand than math
    display_score score if match

    if !match || score[who_won] >= MATCH_WIN_LIMIT # game / match is over
      if match
        display_match_results who_won
        score = create_zero_score # Forgot to zero score on match win
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
