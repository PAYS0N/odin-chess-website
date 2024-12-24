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
      player_setup
      @game_board = OdinChess::GameBoard.new(@player1, @player2)
    end

    def load_game
      raise "load unimplemented"
    end

    def player_setup
      @player1.name = OdinChess::UI.grab_name
      @player2.name = OdinChess::UI.grab_name
      first_player_name = OdinChess::UI.grab_first(@player1.name, @player2.name)
      (first_player_name == @player1.name ? @player1 : @player2).active = true
      (first_player_name == @player1.name ? @player1 : @player2).color = "w"
      (first_player_name == @player1.name ? @player2 : @player1).color = "b"
    end

    def take_turn
      OdinChess::UI.display_board(@game_board.game_state, (@player1.active == true ? "w" : "b"))
      move = OdinChess::UI.grab_move(@game_board, @game_board.grab_active_player)
      return save_quit if move == "SQ"

      @game_board.apply_move(move)
      @player1.swap_active
      @player2.swap_active
      return game_over if @game_board.game_ended

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
