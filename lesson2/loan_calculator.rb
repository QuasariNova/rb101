# Take everything you've learned so far and build a mortgage calculator (or car
# payment calculator -- it's the same thing).
#
# You'll need three pieces of information:
#
#     the loan amount
#     the Annual Percentage Rate (APR)
#     the loan duration
#
# From the above, you'll need to calculate the following things:
#
#     monthly interest rate
#     loan duration in months
#     monthly payment
#
# You can use the following formula:
#
# Mortgage Calculator Formula
#
# Translated to Ruby, this is what the formula looks like:
#
# m = p * (j / (1 - (1 + j)**(-n)))
#
#     m = monthly payment
#     p = loan amount
#     j = monthly interest rate
#     n = loan duration in months
#
# When you write your program, don't use the single-letter variables m, p, j,
# and n; use explicit names. For instance, you may want to use
# loan_amount instead of p.
#
# Finally, don't forget to run your code through Rubocop.
#
# Hints:
#
#     Figure out what format your inputs need to be in. For example, should the
#     interest rate be expressed as 5 or .05, if you mean 5%
#     interest?
#     If you're working with Annual Percentage Rate (APR), you'll need to
#     convert that to a monthly interest rate.
#     Be careful about the loan duration -- are you working with months or
#     years? Choose variable names carefully to assist in remembering.
#     You can use this loan calculator to check your results.
#
require 'io/console'

def valid_number?(num_string) # used to check if a number was input
  return false if num_string[0] == '-' # negative number
  return true if num_string.to_i.to_s == num_string
  float_string = num_string.to_f.to_s
  return true if float_string == num_string
  return true if float_string.chop == num_string # "So like 3. == 3."
  false
end

def calculate_mpr_from_apr(apr) # get monthly interest from annual
  apr / 12.0
end

def calculate_months_from_years(years) # get number of months off of years
  years * 12
end

def calculate_monthly_payment(loan_amount, monthly_interest, month_duration)
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

# ask_for_number promts prompt,
def ask_for_number(message, integer: true)
  value_string = ''
  loop do
    prompt("#{message} ", print_it: true)
    value_string = gets.chomp
    break if valid_number? value_string
    prompt "Please give a valid number."
  end
  integer ? value_string.to_i : value_string.to_f
end

# Start of program:
$stdout.clear_screen
loan_amount = ask_for_number "What is the loan amount being asked for:"
years = ask_for_number "How many years are you willing to spend paying this" \
  " off?"
apr = ask_for_number("What is the APR for the loan? (EX: 5% would be 5)",
                     integer: false)

mpr = calculate_mpr_from_apr(apr / 100.0)
months = calculate_months_from_years years
payment = calculate_monthly_payment(loan_amount, mpr, months)

total_owed = payment * months

# Let's output that info
$stdout.clear_screen
prompt "Loan Amount: $#{format('%.2f', loan_amount)}".rjust(30)
prompt "Duration(months): #{months}".rjust(30)
prompt "APR: #{format('%.1f', apr)}%".rjust(30)
prompt '-' * 30
prompt "Payment: $#{format('%.2f', payment)}".rjust(30)
prompt '-' * 30
prompt "Total Payment: $#{format('%.2f', total_owed)}".rjust(30)
