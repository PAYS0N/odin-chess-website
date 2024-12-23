# frozen_string_literal: true

# module to store chess game
module OdinChess
  # class that stores logic for interacting with user
  class UI
    def self.main_menu
      prompt = "Would you like to start a new game (N), Load a game (L), or quit (Q)?"
      # TODO: change this from must be capital?
      error_msg = "Please enter a single character, one of N, L, or Q. Must be capital."
      prep_proc = ->(input) { input.strip }
      test = ->(string) { %(N L Q).include?(string) }
      OdinChess::InputValidation.verify_input(prompt, error_msg, prep_proc, test)
    end

    def self.grab_name
      prompt = "What is your name?"
      error_msg = "Please enter anything non-empty."
      prep_proc = ->(input) { input.strip }
      OdinChess::InputValidation.verify_input(prompt, error_msg, prep_proc)
    end

    def self.grab_first(name1, name2)
      prompt = "Who wants to go first?"
      error_msg = "Please enter a player name."
      prep_proc = ->(input) { input.strip }
      test = ->(string) { [name1, name2].include?(string) }
      OdinChess::InputValidation.verify_input(prompt, error_msg, prep_proc, test)
    end

    def self.grab_move(game, player)
      prompt = "What is #{player.name}'s move? (#{player.color}) You can also save and quit by entering \"SQ\""
      error_msg = "Please enter a valid move. Instead, to save and quit, enter \"SQ\""
      prep_proc = ->(input) { input.strip == "SQ" ? "SQ" : game.parse(input.strip) }
      test = ->(string) { string == "SQ" || game.valid?(string) }
      OdinChess::InputValidation.verify_input(prompt, error_msg, prep_proc, test)
    end

    def self.display_board(game_state)
      puts "-------------------------------------"
      7.downto(0) do |i|
        print "#{i + 1}   "
        game_state[i].each do |piece|
          print "|#{piece.piece_to_s}"
        end
        puts "|"
        puts "-------------------------------------"
      end
      puts "    |   |   |   |   |   |   |   |   |"
      puts "    | a | b | c | d | e | f | g | h |"
    end
  end
end
