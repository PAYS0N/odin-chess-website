# frozen_string_literal: true

require_relative("game_manager")
require_relative("player")

# module to store chess game
module OdinChess
  # class that stores logic for interacting with user
  class UI
    def play_game
      choice = main_menu
      if choice == "newgame"
        create_game
        take_turn
      elsif choice == "loadgame"
        load_game
        take_turn
      end
    end

    def main_menu
      puts "options - autochose new game"
      "newgame"
    end

    def create_game
      @player1 = OdinChess::Player.new
      @player2 = OdinChess::Player.new
      setup(@player1)
      setup(@player2)
      @game = OdinChess::GameManager.new(@player1, @player2)
    end

    def load_game
      raise "load unimplemented"
    end

    def setup(player)
      puts "Whats ur name"
      player.name = "Jack"
    end

    def take_turn
      move = grab_move
      return save_quit if move == "sq"

      move = parse_move(move)
      @game.apply_move(move)
      return game_over if @game.game_ended

      take_turn
    end

    def grab_move
      puts "what move?"
      "Ra1xa8"
    end

    def parse_move(move)
      %w[0 0 0 7 true]
    end

    def game_over
      puts "game_over"
    end

    def save_quit
      puts "not saved and quit"
      main_menu
    end
  end
end
