require 'io/console'
require 'yaml'

MESSAGES = YAML.load_file "loan_calculator_revised.yaml"
MONTHS_IN_YEAR = 12 # No magic numbers, use a constant instead

# use a yaml to remove strings
def get_message(message)
  MESSAGES[message]
end

# We allow zero's with the last version, now I want it to be optional. APR
# could be zero, the other inputs can't.
def valid_number?(num_string, allow_zero: true)
  return false if num_string.start_with? == '-' # negative number
  int_value = num_string.to_i
  return false if int_value == 0 && !allow_zero
  return true if int_value.to_s == num_string
  float_string = num_string.to_f.to_s
  return true if float_string == num_string || float_string.chop == num_string
  false
end

def calculate_mpr_from_apr(apr)
  apr / MONTHS_IN_YEAR
end

def calculate_months_from_years(years)
  years * MONTHS_IN_YEAR
end

# if APR was 0, this will divide by zero, which is bad. I added a check for that
def calculate_monthly_payment(loan_amount, monthly_interest, month_duration)
  return loan_amount / month_duration.to_f if monthly_interest == 0
  loan_amount * (monthly_interest / (1 -
    (1 + monthly_interest)**(-month_duration)))
end

def prompt(message, print_it: false)
  string = "=> #{message}"
  if print_it
    print string
  else
    puts string
  end
end

def ask_for_number(message, integer: true, allow_zero: false)
  value_string = ''
  loop do
    prompt("#{message} ", print_it: true)
    value_string = gets.chomp
    break if valid_number?(value_string, allow_zero: allow_zero)
    prompt get_message('num_error')
  end
  integer ? value_string.to_i : value_string.to_f
end

# Start of program:
prompt get_message('welcome')
loop do
  $stdout.clear_screen
  loan_amount = ask_for_number get_message('loan_amount_prompt')

  years = ask_for_number get_message('years_prompt')

  apr = ask_for_number(get_message('apr_prompt'),
                       integer: false,
                       allow_zero: true)

  mpr = calculate_mpr_from_apr(apr / 100.0)
  months = calculate_months_from_years years
  payment = calculate_monthly_payment(loan_amount, mpr, months)

  total_owed = payment * months

  # Let's output that info
  $stdout.clear_screen
  prompt (get_message('loan_amount') + format('%.2f', loan_amount)).rjust(30)
  prompt (get_message('duration') + months.to_s).rjust(30)
  prompt (get_message('apr') + "#{format('%.1f', apr)}%").rjust(30)
  prompt '-' * 30
  prompt (get_message('payment') + format('%.2f', payment)).rjust(30)
  prompt '-' * 30
  prompt (get_message('total') + format('%.2f', total_owed)).rjust(30)

  # nice to have a way to ask if they want to calculate again
  continue = loop do
    prompt(get_message('again'), print_it: true)
    answer = gets.downcase
    break true if answer.start_with?('y')
    break false if answer.start_with?('n')
    prompt(get_message('again_error'))
  end
  break if !continue
end
prompt get_message('goodbye')
