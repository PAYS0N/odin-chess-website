# frozen_string_literal: true

require_relative("game_board")
require_relative("player")
require_relative("input_validation")
require_relative("ui")

require "json"

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
      end
    end

    def create_game
      @player1 = OdinChess::Player.new
      @player2 = OdinChess::Player.new
      player1_is_first = player_setup
      @game_board = OdinChess::GameBoard.new(@player1, @player2, player1_is_first)
    end

    def player_setup
      @player1.name = OdinChess::UI.grab_name
      @player2.name = OdinChess::UI.grab_name
      first_player_name = OdinChess::UI.grab_first(@player1.name, @player2.name)
      @player1.color = (first_player_name == @player1.name ? "w" : "b")
      @player2.color = (first_player_name == @player1.name ? "b" : "w")
      first_player_name == @player1.name
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

    def grab_saves
      file = File.read("saves.json")
      JSON.parse(file)
    end

    def save_quit
      saves = grab_saves
      saves.push(@game_board.to_json)
      File.write("saves.json", JSON.pretty_generate(saves))
      play_game
    end

    def load_game
      saves = grab_saves
      display_saves(saves)
      save_to_play = OdinChess::UI.grab_save_selection(saves.length)
      return play_game if save_to_play == -2

      @game_board = OdinChess::GameBoard.new(0, 0, false)
      @game_board.from_json(saves[save_to_play])
      saves.delete_at(save_to_play)
      File.write("saves.json", JSON.pretty_generate(saves))
      take_turn
    end

    def display_saves(saves)
      saves.each_with_index do |save, i|
        puts "Load game #{i + 1}: "
        game = OdinChess::GameBoard.new(0, 0, false)
        game.from_json(save)
        OdinChess::UI.display_board(game.game_state, game.active_color)
      end
    end
  end
end
