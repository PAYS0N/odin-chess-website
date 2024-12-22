# frozen_string_literal: true

# module to store chess game
module OdinChess
  # class to store game state and logic
  class GameBoard
    attr_reader :game_ended

    def initialize(player1, player2, active_player)
      @player1 = player1
      @player2 = player2
      @active_player = active_player
      @game_ended = false
      @game_state = 0
    end

    def apply_move(move)
      @game_state += 1
      @game_ended = true if @game_state > 9
    end

    def parse(move)
      puts "unparsed move: #{move}"
      move
    end

    def valid?(move)
      puts "unvalidated move: #{move}"
      true
    end
  end
end
