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

    def self.grab_move(game)
      prompt = "What is your move? You can also save and quit by entering \"SQ\""
      error_msg = "Please enter a valid move. Instead, to save and quit, enter \"SQ\""
      prep_proc = ->(input) { game.parse(input.strip) }
      test = ->(string) { game.valid?(string) || string == "SQ" }
      OdinChess::InputValidation.verify_input(prompt, error_msg, prep_proc, test)
    end
  end
end
