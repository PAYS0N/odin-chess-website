# frozen_string_literal: true

# module to store chess game
module OdinChess
  # class to store game state and logic
  class GameManager
    attr_reader :game_ended

    def initialize(player1, player2)
      @player1 = player1
      @player2 = player2
      @game_ended = false
      @game_state = 0
    end

    def apply_move(move)
      @game_state += 1
      @game_ended = true if @game_state > 9
    end
  end
end
