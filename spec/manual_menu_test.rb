require "./lib/menu"

class TestXYZ
  def initialize
  end
  def test_x
     puts "X test action has occurred!"
  end
  def test_z
      puts "Z test action has occurred!"
  end
  def test_y
    puts "Y test action has occurred!"
  end
end

tester_obj = TestXYZ.new


test_menu_level_1 = Menu.new([], "Test Main Menu.")
test_menu_level_2 = Menu.new([], "Test Submenu One.")

test_menu_option_a1 = MenuOption.new("1", "This will take Action Z", false, tester_obj, :test_z)
test_menu_option_b1 = MenuOption.new("2", "This will take Action X", false, tester_obj, :test_x)
test_menu_option_c1 = MenuOption.new("3", "This will open a submenu", false, test_menu_level_2, :display)
test_menu_option_d1 = MenuOption.new("4", "This will take Action Z and exit the menu", true, tester_obj, :test_z)

test_menu_option_a2 = MenuOption.new("1", "This will take Action Y", false, tester_obj, :test_y)
test_menu_option_b2 = MenuOption.new("2", "This will print the exact same words that appears here again", false, :output)
test_menu_option_c2 = MenuOption.new("3", "This will take Action Y and exit the submenu", test_menu_level_2, true, :exit_menu)

test_menu_level_1.add_options([test_menu_option_a1, test_menu_option_b1, test_menu_option_c1, test_menu_option_d1])
test_menu_level_2.add_options([test_menu_option_a2, test_menu_option_b2, test_menu_option_c2])

test_menu_level_1.display()
