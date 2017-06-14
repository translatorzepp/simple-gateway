require "transaction"

RSpec.describe Transaction do

	it "has an amount which strips out unnecessary non-digit charcters and renders the empty string as zero" do
		trans = Transaction.new("transactionuid1", "merchant1", "$56.242")
		expect(trans.amount).to eq("56.242")
		trans = Transaction.new("transactionuid1", "merchant1", "zero hundred 56 dollars and twenty-four cents")
    expect(trans.amount).to eq("56")
    trans = Transaction.new("transactionuid1", "merchant1", "")
    expect(trans.amount).to eq("0")
    trans = Transaction.new("transactionuid1", "merchant1", "not a number -> zero")
    expect(trans.amount).to eq("0")
  end

end

RSpec.describe TransactionStore do

  before(:each) do
    @tstore = TransactionStore.new
    @tstore.add_transaction(Transaction.new("id19", "Justice of Toren", "19"))
    @tstore.add_transaction(Transaction.new("id91", "Seivarden", "zero"))
    @tstore.add_transaction(Transaction.new("id1235813", "Athoek Station", "21.21"))
    @tstore.add_transaction(Transaction.new("id21345589", "Athoek Station", "42.42"))
    @tstore.add_transaction(Transaction.new("id0246", "Mercy of Kalr", "100"))
    @tstore.add_transaction(Transaction.new("id0190", "Justice of Toren", "19"))
  end

	it "takes in new transactions" do
    expect(@tstore.transactions[@tstore.transactions.keys.sample].class).to eq(Transaction.new("id", "m", "1").class)
    expect(@tstore.transactions["id19"].merchant_name).to eq("Justice of Toren")
    expect(@tstore.transactions["id1235813"].amount).to eq("21.21")
	end

  it "counts the number of transactions" do
    expect(@tstore.transaction_count).to eq(6)
  end

  it "tracks the merchants that have transactions in alphabetical order" do
    expect(@tstore.all_merchants.length).to eq(4)
    expect(@tstore.all_merchants[0]).to eq("Athoek Station")
    expect(@tstore.all_merchants[1]).to eq("Justice of Toren")
    expect(@tstore.all_merchants[2]).to eq("Mercy of Kalr")
    expect(@tstore.all_merchants[3]).to eq("Seivarden")
  end

  it "checks if it already contains a transaction with specified ID" do
    expect(@tstore.is_transaction_id_unique("id19")).to eq(false)
    expect(@tstore.is_transaction_id_unique("doesnotexist")).to eq(true)
  end

  it "sums the amount of all trasactions it contains" do
    expect(@tstore.total_amount).to eq(201.63)
  end

  it "counts an empty string as zero when summing amounts" do
    tstore_seivarden = @tstore.new_transaction_store_for_merchant("Seivarden")
    expect(tstore_seivarden.total_amount).to eq(0)
  end

	it "only adds transactions if their IDs have not been taken" do
    dup_id = "id19"
    @tstore.add_transaction(Transaction.new(dup_id, "Justice of Toren", "44.44"))
    expect(@tstore.transactions[dup_id].amount).not_to eq("44.44")
	end

  it "outputs a record of all transactions with the total count and sum of amounts" do
    output = @tstore.output_transaction_summary()
    expect(output).to start_with("All merchants: 6 transactions totalling $201.63")
    expect(output).to include("Justice of Toren,id19,19")
    expect(output).to include("Justice of Toren,id0190,19")
    expect(output).to include("Mercy of Kalr,id0246,100")
    expect(output).to include("Athoek Station,id1235813,21.21")
    expect(output).to include("Athoek Station,id21345589,42.42")
    expect(output).to include("Seivarden,id91,0")
  end

  it "creates new TransactionStores for a designated merchant and only that merchant" do
    jot = "Justice of Toren"
    tstore_justice_of_toren = @tstore.new_transaction_store_for_merchant(jot)
    expect(tstore_justice_of_toren.transaction_count).to eq(2)
    expect(tstore_justice_of_toren.total_amount).to eq(38)
    expect(tstore_justice_of_toren.transactions["id19"].merchant_name).to eq(jot)
    expect(tstore_justice_of_toren.transactions["id0190"]).to be
    expect(tstore_justice_of_toren.transactions["idid0246"]).to be_nil
  end

  it "outputs all transactions by merchant with summaries" do
    summary = CSV.parse(@tstore.full_output_by_merchants())
    expect(summary[0]).to eq(["Athoek Station: 2 transactions totalling $63.63"])
    expect(summary[1]).to include("Athoek Station")
    expect(summary[2]).to include("Athoek Station")
    expect(summary[3]).to eq(["Justice of Toren: 2 transactions totalling $38.00"])
    expect(summary[4]).to include("Justice of Toren")
    expect(summary[5]).to include("Justice of Toren")
    expect(summary[6]).to eq(["Mercy of Kalr: 1 transactions totalling $100.00"])
    expect(summary[7]).to include("Mercy of Kalr")
    expect(summary[8]).to eq(["Seivarden: 1 transactions totalling $0.00"])
    expect(summary.length).to eq(10)
  end

  it "can be reset to delete all transactions" do
    @tstore.reset()
    expect(@tstore.all_merchants.length).to eq(0)
    expect(@tstore.transaction_count).to eq(0)
    expect(@tstore.total_amount).to eq(0)
    expect(@tstore.transactions["id19"]).to be_nil
  end

  it "creates a new transactionstore with all transactions whose id matches a search string" do
    searchtstore = @tstore.search("id19")
    expect(searchtstore.class).to eq(@tstore.class)
    expect(searchtstore.transaction_count).to eq(1)
  end

  it "creates a new transactionstore with all transactions whose merchant name matches a search string" do
    searchtstore = @tstore.search("JUSTICE OF tOREn")
    expect(searchtstore.transaction_count).to eq(2)
    expect(searchtstore.all_merchants.length).to eq(1)
  end

  it "returns partial matches on search results" do
    @tstore.add_transaction(Transaction.new("variable", "a new merchant", "0"))
    searchtstore = @tstore.search("var")
    expect(searchtstore.transaction_count).to eq(2)
  end




















end
