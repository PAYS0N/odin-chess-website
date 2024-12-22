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
      puts "move not applied"
      @game_ended = true if @game_state > 9
    end

    def parse(move)
      move = move.chars
      return parse_castle(move) if move.include?("0")

      if move.include?("x")
        return parse_piece_capture(move) if move.any? { |char| char.match?(/[A-Z]/) }

        parse_pawn_capture(move)
      else
        return parse_piece_move(move) if move.any? { |char| char.match?(/[A-Z]/) }

        parse_pawn_move(move)
      end
    rescue NoMethodError => e
      raise unless e.message.include?("undefined method `ord'")

      ["Invalid"]
    end

    def parse_castle(move)
      return ["Castle"] if move == %w[0 - 0]
      return ["Long castle"] if move == %w[0 - 0 - 0]

      ["Invalid"]
    end

    def parse_piece_capture(move)
      [move[0], move[1].ord - 97, move[2].to_i - 1, move[4].ord - 97, move[5].to_i - 1]
    end

    def parse_pawn_capture(move)
      ["P", move[0].ord - 97, move[1].to_i - 1, move[3].ord - 97, move[4].to_i - 1]
    end

    def parse_piece_move(move)
      [move[0], move[1].ord - 97, move[2].to_i - 1, move[3].ord - 97, move[4].to_i - 1]
    end

    def parse_pawn_move(move)
      ["P", move[0].ord - 97, move[1].to_i - 1, move[2].ord - 97, move[3].to_i - 1]
    end

    def valid?(move)
      puts "unvalidated move: #{move}"
      true
    end
  end
end
