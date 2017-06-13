require "menu"

class TestXYZ
  def initialize()
  end
  def test_x()
     puts "X test action has occurred!"
  end
  def test_z()
      puts "Z test action has occurred!"
  end
end

RSpec.describe MenuOption do

  it "calls a method specified as its action" do
    tester_obj = TestXYZ.new
    a_menu_option = MenuOption.new("a", "This will take Option Z", false, tester_obj, :test_z)
    expect { a_menu_option.act() }.to output("Z test action has occurred!\n").to_stdout
  end

end

RSpec.describe Menu do

  before(:each) do
    tester_obj = TestXYZ.new
    @test_menu_option_a = MenuOption.new("a", "This will take Option Z", false, tester_obj, :test_z)
    @test_menu_option_b = MenuOption.new("b", "This will take Option X", false, tester_obj, :text_x)
    @test_menu_option_c = MenuOption.new("c", "This will take Option Z and exit the menu", true, tester_obj, :test_z)
    @test_menu = Menu.new([@test_menu_option_a, @test_menu_option_b, @test_menu_option_c], "Test Main Menu.")
  end

  it "has options from initialization" do
    test_menu_options = @test_menu.instance_variable_get(:@options)
    expect(test_menu_options["a"].description).to eq("This will take Option Z")
  end

  it "has a list of the keys for each option" do
    expect(@test_menu.instance_variable_get(:@options_keys)).to eq(["a", "b", "c"])
  end

  it "displays a title, the exit key, and each of its options' descriptions" do
    allow(@test_menu).to receive(:gets).and_return("#{@test_menu.instance_variable_get(:@exit_choice)}\n")
    expect { @test_menu.display() }.to output(
      "\nTest Main Menu.\n(enter '#{@test_menu.instance_variable_get(:@exit_choice)}' to exit)\na  This will take Option Z\nb  This will take Option X\nc  This will take Option Z and exit the menu\n").to_stdout
    #update ^ to all variables or none
  end

end
