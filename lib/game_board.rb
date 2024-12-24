# frozen_string_literal: true

require_relative("piece")

require "json"

# module to store chess game
module OdinChess
  # class to store game state and logic
  class GameBoard
    attr_reader :game_ended, :game_state

    def initialize(player1, player2, game_state = [])
      @player1 = player1
      @player2 = player2
      @game_ended = false
      @game_state = game_state
      return unless @game_state == []

      8.times do
        @game_state.push([])
      end
      setup_game_state
    end

    def to_json(*_args)
      { player1: @player1.to_obj, player2: @player2.to_obj, game_state: board_to_obj(@game_state) }.to_json
    end

    def board_to_obj(state)
      json_state = []
      state.each_with_index do |row, i|
        json_state.push([])
        row.each do |piece|
          json_state[i].push(piece.to_obj)
        end
      end
      json_state
    end

    def self.from_json(json_str)
      data = JSON.parse(json_str)
      player1 = OdinChess::Player.from_obj(data["player1"])
      player2 = OdinChess::Player.from_obj(data["player2"])
      new(player1, player2, board_from_obj(data["game_state"]))
    end

    def board_from_obj(obj)
      state = []
      8.times do |i|
        state.push([])
        8.times do |j|
          state[i].push(OdinChess::Piece.from_obj(obj[i][j]))
        end
      end
      state
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
      @game_state[row].push(OdinChess::Rook.new(color))
      @game_state[row].push(OdinChess::Knight.new(color))
      @game_state[row].push(OdinChess::Bishop.new(color))
      @game_state[row].push(OdinChess::Queen.new(color))
      @game_state[row].push(OdinChess::King.new(color))
      @game_state[row].push(OdinChess::Bishop.new(color))
      @game_state[row].push(OdinChess::Knight.new(color))
      @game_state[row].push(OdinChess::Rook.new(color))
    end

    def setup_pawn_row(row, color)
      8.times do
        @game_state[row].push(OdinChess::Pawn.new(color))
      end
    end

    def setup_empty_row(row)
      8.times do
        @game_state[row].push(OdinChess::EmptyPiece.new("g"))
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
      piece_class = Piece.grab_class_from_letter(move[0])
      [piece_class, move[2].to_i - 1, move[1].ord - 97, move[5].to_i - 1, move[4].ord - 97, 1]
    end

    def parse_pawn_capture(move)
      [OdinChess::Pawn, move[1].to_i - 1, move[0].ord - 97, move[4].to_i - 1, move[3].ord - 97, 1]
    end

    def parse_piece_move(move)
      piece_class = Piece.grab_class_from_letter(move[0])
      [piece_class, move[2].to_i - 1, move[1].ord - 97, move[4].to_i - 1, move[3].ord - 97, 0]
    end

    def parse_pawn_move(move)
      [OdinChess::Pawn, move[1].to_i - 1, move[0].ord - 97, move[3].to_i - 1, move[2].ord - 97, 0]
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
      piece_at_cell(move[0], [move[1], move[2]]) &&
        target_cell_ok([move[3], move[4]], move[5]) &&
        piece_can_move(move) &&
        move_doesnt_lose(move)
    end

    def piece_at_cell(piece, cell)
      passes = @game_state[cell[0]][cell[1]].is_a?(piece)
      if passes == false
        puts "The piece you indicated #{piece} is not at that starting cell [#{cell[0]}, #{cell[1]}]. #{@game_state[cell[0]][cell[1]].piece_to_s.strip} is."
      end
      passes
    end

    def target_cell_ok(cell, move_type)
      return @game_state[cell[0]][cell[1]].is_a?(EmptyPiece) if move_type.zero?

      target_color = @player1.active == true ? "b" : "w"
      @game_state[cell[0]][cell[1]].color == target_color
    end

    def piece_can_move(move)
      cells = if move[5] == 1
                @game_state[move[1]][move[2]].grab_available_captures(@game_state, move)
              else
                @game_state[move[1]][move[2]].grab_available_moves(@game_state, move)
              end
      cells.include?([move[3], move[4]])
    end

    def move_doesnt_lose(move)
      puts "Unchecked if #{move} loses"
      true
    end

    def grab_active_player
      @player1.active ? @player1 : @player2
    end
  end
end
