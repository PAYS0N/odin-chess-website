# frozen_string_literal: true

require_relative("piece")

module OdinChess
  # class that stores player name
  class Move
    attr_accessor :type, :p_class, :row, :col, :target_row, :target_col, :is_capture

    def initialize(type, piece_class = nil, piece_cell = nil, target_cell = nil, is_capture = nil)
      @type = type
      @p_class = piece_class
      @row = piece_cell[0] unless piece_cell.nil?
      @col = piece_cell[1] unless piece_cell.nil?
      @target_row = target_cell[0] unless target_cell.nil?
      @target_col = target_cell[1] unless target_cell.nil?
      @is_capture = is_capture
    end

    # from Ra1xa2
    def self.from_piece_capture(move)
      method = "Normal"
      p_class = OdinChess::Piece.grab_class_from_letter(move[0])
      row = move[2].to_i - 1
      col = move[1].ord - 97
      target_row = move[5].to_i - 1
      target_col = move[4].ord - 97
      is_capture = true
      OdinChess::Move.new(method, p_class, [row, col], [target_row, target_col], is_capture)
    end

    # from a1xa2
    def self.from_pawn_capture(move)
      method = "Normal"
      p_class = OdinChess::Pawn
      row = move[1].to_i - 1
      col = move[0].ord - 97
      target_row = move[4].to_i - 1
      target_col = move[3].ord - 97
      is_capture = true
      OdinChess::Move.new(method, p_class, [row, col], [target_row, target_col], is_capture)
    end

    # from Ra1a2
    def self.from_piece_move(move)
      method = "Normal"
      p_class = OdinChess::Piece.grab_class_from_letter(move[0])
      row = move[2].to_i - 1
      col = move[1].ord - 97
      target_row = move[4].to_i - 1
      target_col = move[3].ord - 97
      is_capture = false
      OdinChess::Move.new(method, p_class, [row, col], [target_row, target_col], is_capture)
    end

    # from a1a2
    def self.from_pawn_move(move)
      method = "Normal"
      p_class = OdinChess::Pawn
      row = move[1].to_i - 1
      col = move[0].ord - 97
      target_row = move[3].to_i - 1
      target_col = move[2].ord - 97
      is_capture = false
      OdinChess::Move.new(method, p_class, [row, col], [target_row, target_col], is_capture)
    end

    def self.from_string(move)
      move = move.chars

      case
      when move.include?("0") then OdinChess::Move.parse_castle(move)
      when move.include?("=") then OdinChess::Move.parse_promote(move)
      when move.include?("x")
        return OdinChess::Move.from_piece_capture(move) if move.any? { |char| char.match?(/[A-Z]/) }

        OdinChess::Move.from_pawn_capture(move)
      else
        return OdinChess::Move.from_piece_move(move) if move.any? { |char| char.match?(/[A-Z]/) }

        OdinChess::Move.from_pawn_move(move)
      end
    rescue NoMethodError => e
      raise unless e.message.include?("undefined method `ord'")

      OdinChess::Move.new("Invalid")
    end

    def self.parse_castle(move)
      return OdinChess::Move.new("Castle") if move == %w[0 - 0]
      return OdinChess::Move.new("Long Castle") if move == %w[0 - 0 - 0]

      OdinChess::Move.new("Invalid")
    end

    def technically_valid?
      @row && @col && @target_row && @target_col &&
        [@row, @col, @target_col, @target_row].all? { |int| int.between?(0, 7) }
    end
  end
end
