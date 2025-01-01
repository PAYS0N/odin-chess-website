# frozen_string_literal: true

require_relative("game_board")
require_relative("player")
require_relative("input_validation")
require_relative("ui")

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
      player1_is_first = player_setup
      @game_board = OdinChess::GameBoard.new(@player1, @player2, player1_is_first)
    end

    def load_game
      raise "load unimplemented"
    end

    def player_setup
      @player1.name = OdinChess::UI.grab_name
      @player2.name = OdinChess::UI.grab_name
      first_player_name = OdinChess::UI.grab_first(@player1.name, @player2.name)
      player1_is_white = first_player_name == @player1.name
      @player1.color = (player1_is_white ? "w" : "b")
      @player2.color = (player1_is_white ? "b" : "w")
    end

    def take_turn
      OdinChess::UI.display_board(@game_board.game_state, @game_board.active_color)
      move = OdinChess::UI.grab_move(@game_board, @game_board.active_player)
      return save_quit if move == "SQ"

      @game_board.apply_move(move)
      @game_board.post_move_updates
      @game_board.check_game_over
      return game_over if @game_board.game_ended

      take_turn
    end

    def game_over
      puts "Checkmate!"
      OdinChess::UI.display_board(@game_board.game_state, @game_board.active_color)
    end

    def save_quit
      puts "not saved and quit"
      play_game
    end
  end
end
