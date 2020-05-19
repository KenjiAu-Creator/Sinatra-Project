  class Player
    def initialize(color_choices)
      @color_choices = color_choices
    end
    attr_accessor :color_choices
  end

  class MasterMind
    def initialize
    end

    def choose_color_message
      puts "Please choose four colors in any order separated by a comma"
      puts "Ex. R,G,Y,B"
    end

    def get_human_choice
      ans = gets.chomp
      ans = ans.split(",")
    end

    def get_random_choice
      puts "Computer is now choosing colors..."
      colors = ["Red", "Blue", "Green", "Yellow"]
      choice = colors.sample(4)
    end

    def computer_guesses
      @available = [0, 1, 2, 3]
      choose_color_message
      @human = Player.new(get_human_choice)
      @computer = Player.new(get_random_choice)
      code_compare
      @@guess_count = 1
      @@guess_hash = Hash.new
      computer_guess_play
    end

    def computer_code_maker
      @computer = Player.new(get_random_choice)
      choose_color_message
      @human = Player.new(get_human_choice)
      code_compare
      @@guess_count = 1
      @@guess_hash = Hash.new
      computer_code_maker_play
    end

    def who_creates_code
      puts "Would you like to be the code maker or the code breaker?"
      choose = gets.chomp.downcase
      input_valid(choose)
    end

    def input_valid(choose)
      if choose == "code maker"
        computer_guesses
      elsif choose == "code breaker"
        computer_code_maker
      else
        puts "Invalid choice"
        who_creates_code
      end
    end

    def color_match(color)
      human.color_choices.include? color
    end

    def store_human_guess
      @@guess_hash[@human.color_choices] = match_message
    end

    def match_message
      puts "Here is your hint: #{@hint_colors}"
    end

    def code_compare
      @hint_colors = Array.new
      @computer.color_choices.each_with_index do |color, index|
        if @human.color_choices[index] == color
          @hint_colors[index] = "Black"
        else
          @hint_colors[index] = ""
        end
      end
    end

    def code_compare2(playerGuess,computerCode)
      @hint_colors = Array.new
      computerCode.each_with_index do |color, index|
        if playerGuess[index] == color
          @hint_colors[index] = "Black"
        else
          @hint_colors[index] = "Blank"
        end
      end
    end

    def hints?
      return @hint_colors
    end

    def win_condition
      count = 0
      @hint_colors.each do |color|
        if color == "Black"
          count += 1
        end
      end
      
      if count == 4
        return true
      else
        return false
      end
    end

    def guess_again_message
      puts "You didn't crack the code! Guess again!"
    end

    def computer_code_maker_play
      while @@guess_count <= 12
        if win_condition
          puts "Game over! Code breaker wins!"
          game_over = true
          break
        end
        store_human_guess
        guess_again_message
        @human.color_choices = get_human_choice
        code_compare
        @@guess_count += 1
      end
      puts "Game over! Code maker wins!"
    end

    def store_computer_guess
      @@guess_hash[@computer.color_choices] = match_message
    end

    def computer_guess_play
      @available_peg_choices = { 0 => "RBGY", 1 => "RBGY", 2  => "RBGY", 3  => "RBGY"}
      while @@guess_count <=12
        if win_condition
          puts "Gave over! Code breaker wins!"
          break
        end

        store_computer_guess
        @computer.color_choices = update_guess
        code_compare
        @@guess_count += 1

        if @@guess_count == 12
          puts "Game over! Code maker wins!"
        end
      end
    end

    def update_guess
      new_guess = Array.new 
      @hint_colors.each_with_index do |color, index|
        if color == 'Black'
          new_guess[index] = @computer.color_choices[index]
        else
          @available_peg_choices[index].gsub!(color, "")
          new_random_color = @available_peg_choices[index].split("").sample(1).join("")
          new_guess[index] = new_random_color
        end
      end
      puts "The new guess is:"
      puts new_guess.inspect
      return new_guess
    end
  end