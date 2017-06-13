require_relative "menu"
require_relative "transaction"

class Gateway

  attr_accessor :transaction_store
  attr_accessor :menu
  def initialize
    @transaction_store = TransactionStore.new
    add_transaction_option = MenuOption.new("+", "Add a transaction", false, self, :add_transaction_from_input)
    summary_and_continue_option = MenuOption.new("=", "Show summary and continue", false, @transaction_store, :full_output_by_merchants)
    start_over_option = MenuOption.new("0", "Start over", false, @transaction_store, :reset)
    summary_and_exit_option = MenuOption.new(">", "Done adding transactions (show summary and exit)", true, @transaction_store, :full_output_by_merchants)
    @menu = Menu.new([add_transaction_option, summary_and_continue_option, start_over_option, summary_and_exit_option], "Transaction Gateway")
  end

  def add_transaction_from_input
    puts "Enter a merchant name: "
    merchant = gets.chomp
    puts "Enter an amount: "
    amount = gets.chomp
    puts "Enter a unique ID: "
    id = gets.chomp
    @transaction_store.add_transaction(Transaction.new(id, merchant, amount))
  end
  # this way gateway has to know about transaction *and* transactionstore
  # make this a transaction method?
  # but if it's a transaction method, then transaction has to know about the interface

  def launch
    @menu.display
  end

end
