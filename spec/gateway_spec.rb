require "gateway"

RSpec.describe Gateway do

  before(:each) do
    @gw = Gateway.new
  end

  it "creates a TransactionStore" do
    expect(@gw.transaction_store.class).to eq(TransactionStore.new.class)
  end

  it "launches a menu for adding and displaying transactions" do
    allow(@gw.menu).to receive(:gets).and_return("q\n")
    expect { @gw.launch() }.to output("\nTransaction Gateway\n(enter 'q' to exit)\n+  Add a transaction\n=  Show summary and continue\n0  Start over\n>  Done adding transactions (show summary and exit)\n").to_stdout
  end

end
