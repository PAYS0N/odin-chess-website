# frozen_string_literal: true

require_relative("game_board")
require_relative("player")
require_relative("input_validation")
require_relative("ui")

# module to store chess game
module OdinChess
  # class that stores logic for interacting with user
  class GameManager
    def play_game
      choice = OdinChess::UI.main_menu
      if choice == "N"
        create_game
        take_turn
      elsif choice == "L"
        load_game
        take_turn
      end
    end

    def create_game
      @player1 = OdinChess::Player.new
      @player2 = OdinChess::Player.new
      active_player = player_setup
      @game_board = OdinChess::GameBoard.new(@player1, @player2, active_player)
    end

    def load_game
      raise "load unimplemented"
    end

    def player_setup
      @player1.name = OdinChess::UI.grab_name
      @player2.name = OdinChess::UI.grab_name
      OdinChess::UI.grab_first(@player1.name, @player2.name) == @player1.name ? @player1 : @player2
    end

    def take_turn
      move = OdinChess::UI.grab_move(@game_board)
      return save_quit if move == "SQ"

      @game.apply_move(move)
      return game_over if @game.game_ended

      take_turn
    end

    def game_over
      puts "game_over"
    end

    def save_quit
      puts "not saved and quit"
      play_game
    end
  end
end
