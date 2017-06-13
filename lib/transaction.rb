require "csv"

class Transaction

  attr_reader :public_id
  attr_reader :merchant_name
  attr_reader :amount
  def initialize(id, merch, amt)
    @public_id = id
    @merchant_name = merch
    @amount = sanitize_amount(amt)
  end

  def sanitize_amount(amt)
    stripped_amount = amt.gsub(/[^[\d\.]]/, "")
    stripped_amount.empty? ? "0" : stripped_amount
  end

end

class TransactionStore

  attr_reader :transactions
  attr_accessor :total_amount
  attr_accessor :all_merchants
  attr_accessor :transaction_count
  def initialize
    @transactions = {}
    @total_amount = 0
    @transaction_count = 0
    @all_merchants = []
  end

  def is_transaction_id_unique(public_id)
    !@transactions.has_key?(public_id)
  end

  def add_transaction(transaction)
    new_id = transaction.public_id
    if is_transaction_id_unique(new_id)
      @transactions[new_id] = transaction
      @total_amount = @total_amount + transaction.amount.to_f
      @transaction_count += 1
      unless @all_merchants.include?(transaction.merchant_name)
        @all_merchants << transaction.merchant_name
      end
      @all_merchants.sort!
      # we could derive all this from traversing the hash with each, but this is faster
    else
      # return?
      puts "\nERROR: transaction public id is already in use"
    end
  end

  def output_transaction_summary(name="All merchants")
    output = CSV.generate do | csv |
      csv << ["#{name}: #{@transaction_count} transactions totalling $#{sprintf("%.2f", @total_amount)}"]
      @transactions.each_value do | transaction |
        csv << [transaction.merchant_name, transaction.public_id, transaction.amount]
      end
    end
    return output
  end

  def new_transaction_store_for_merchant(merch)
    merchant_transaction_store = TransactionStore.new
    @transactions.each_value do | trans |
      if trans.merchant_name == merch
        merchant_transaction_store.add_transaction(trans)
      end
    end
    return merchant_transaction_store
  end

  def full_output_by_merchants()
    output = ""
    @all_merchants.each do | merch |
      mtstore = self.new_transaction_store_for_merchant(merch)
      output = output + mtstore.output_transaction_summary(merch)
    end
    puts "\n" + output
    return output
  end

  def reset
    @transactions = {}
    @total_amount = 0
    @transaction_count = 0
    @all_merchants = []
  end

end
