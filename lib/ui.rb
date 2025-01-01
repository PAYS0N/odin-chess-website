# frozen_string_literal: true

require_relative("move")

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
      prompt = "What is #{player.name}'s move? Your pieces are #{player.color}. You can also save and quit by entering \"SQ\""
      error_msg = "Please enter a valid move. Instead, to save and quit, enter \"SQ\""
      prep_proc = ->(input) { input.strip == "SQ" ? "SQ" : OdinChess::Move.from_string(input.strip) }
      test = ->(move) { move == "SQ" || game.valid?(move) }
      OdinChess::InputValidation.verify_input(prompt, error_msg, prep_proc, test)
    end

    def self.grab_promotion_class
      prompt = "What would you like to promote your pawn to?"
      error_msg = "Please enter the character for a non-pawn piece."
      prep_proc = ->(input) { input.strip }
      test = ->(str) { %w[R B N Q].include?(str) }
      OdinChess::InputValidation.verify_input(prompt, error_msg, prep_proc, test)
    end

    def self.grab_save_selection(number_of_saves)
      prompt = "What save do you want to play? You can also enter -1 to go back."
      error_msg = "Please enter a save number."
      prep_proc = ->(input) { input.strip.to_i - 1 }
      test = ->(int) { int == -2 || int.between?(0, number_of_saves - 1) }
      OdinChess::InputValidation.verify_input(prompt, error_msg, prep_proc, test)
    end

    def self.display_board(game_state, color)
      return display_for_white(game_state) if color == "w"

      display_for_black(game_state)
    end

    def self.display_for_white(game_state)
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

    def self.display_for_black(game_state)
      puts "-------------------------------------"
      0.upto(7) do |i|
        print "#{i + 1}   "
        game_state[i].reverse.each do |piece|
          print "|#{piece.piece_to_s}"
        end
        puts "|"
        puts "-------------------------------------"
      end
      puts "    |   |   |   |   |   |   |   |   |"
      puts "    | h | g | f | e | d | c | b | a |"
    end
  end
end
