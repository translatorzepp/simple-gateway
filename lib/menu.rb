class MenuOption

  attr_reader :key
  attr_reader :description
  attr_reader :exit_after
  def initialize(key, description, exit_menu_after_action, action_object=self, action)
    @key = key
    @description = description #the menu option's text
    @exit_after = exit_menu_after_action #should the menu exit after the menu option is executed?
    @action_object = action_object #an object to which the method belongs
    @action = action #a method as symbol that will be called when the menu option is selected
    #maybe make this so it doesn't have to be an object + a method?
  end

  def output()
    puts "#{@key}  #{@description}"
  end

  def act()
    @action_object.method(@action).call
  end

end

class Menu

  def initialize(opt = [], title = "Main menu")
    @options = {} #hash instead of array so it's easy to go from key to action without having to iterate through an array of options checking each key
    @options_keys = [] #manually creating the key array allows us to control order of presentation
    add_options(opt)
    @title = title
    @choice = ""
    @exit_choice = "q" #maybe make this an optional argument with default "q"
  end

  def add_options(opt)
    opt.each do | option |
      @options[option.key] = option
      @options_keys << option.key
    end
  end

  def display
    while @choice != @exit_choice
      if @options_keys.include? @choice
        chosen_option = @options[@choice]
        if chosen_option.exit_after
          @choice = "q"
        else
          @choice = ""
        end
        chosen_option.act
      else
        puts "\n#{@title}"
        puts "(enter '#{@exit_choice}' to exit)"
        @options_keys.each do | menu_option_key |
          @options[menu_option_key].output
        end
        @choice = gets.chomp
      end
    end
    @choice = ""
  end

  #def exit_menu
  #  @choice = @exit_choice
  #end

end

# menu:
  # needs a title
  # needs options
  #   each option should have
  #     a key: e.g. a number
  #     a description: a text string
  #     a method: what it does
  #
    #listen for choice
    #case of every key in each menu_option
    #if choice = case, call key's MenuOption's method
    #alt: listen for choice
    #for each option in the menu's options array,
    # check if choice = option.key; if yes, return option.method
