# frozen_string_literal: true

require_relative("piece")

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
      @game_state = []
      8.times do
        @game_state.push([])
      end
      setup_game_state
    end

    def setup_game_state
      setup_home_row(0, "w")
      setup_pawn_row(1, "w")
      setup_empty_row(2)
      setup_empty_row(3)
      setup_empty_row(4)
      setup_empty_row(5)
      setup_pawn_row(6, "b")
      setup_home_row(7, "b")
    end

    def setup_home_row(row, color)
      @game_state[row].push(OdinChess::Piece.new(color, "rook"))
      @game_state[row].push(OdinChess::Piece.new(color, "knight"))
      @game_state[row].push(OdinChess::Piece.new(color, "bishop"))
      @game_state[row].push(OdinChess::Piece.new(color, "queen"))
      @game_state[row].push(OdinChess::Piece.new(color, "king"))
      @game_state[row].push(OdinChess::Piece.new(color, "bishop"))
      @game_state[row].push(OdinChess::Piece.new(color, "knight"))
      @game_state[row].push(OdinChess::Piece.new(color, "rook"))
    end

    def setup_pawn_row(row, color)
      8.times do
        @game_state[row].push(OdinChess::Piece.new(color, "pawn"))
      end
    end

    def setup_empty_row(row)
      8.times do
        @game_state[row].push(0)
      end
    end

    def apply_move(move)
      puts "#{move} not applied"
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
      [move[0], move[1].ord - 97, move[2].to_i - 1, move[4].ord - 97, move[5].to_i - 1, 1]
    end

    def parse_pawn_capture(move)
      ["P", move[0].ord - 97, move[1].to_i - 1, move[3].ord - 97, move[4].to_i - 1, 1]
    end

    def parse_piece_move(move)
      [move[0], move[1].ord - 97, move[2].to_i - 1, move[3].ord - 97, move[4].to_i - 1, 0]
    end

    def parse_pawn_move(move)
      ["P", move[0].ord - 97, move[1].to_i - 1, move[2].ord - 97, move[3].to_i - 1, 0]
    end

    def valid?(move)
      check_technically_valid(move) && check_logically_valid(move)
    end

    def check_technically_valid(move)
      return true if ["Castle", "Long castle"].include?(move)
      return false if move == ["Invalid"]

      move[1..].all? { |int| int.between?(0, 7) }
    end

    def check_logically_valid(move)
      puts "no logical check for #{move}"
      true
    end
  end
end
