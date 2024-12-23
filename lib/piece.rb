# frozen_string_literal: true

require "colorize"

# module to store chess game
module OdinChess
  # class that stores piece data
  class Piece
    attr_accessor :color, :has_moved, :type

    def initialize(color, type, has_moved = false)
      @color = color
      @has_moved = has_moved
      @type = type
    end

    def to_obj
      { color: @color, has_moved: @has_moved, type: @type }
    end

    def self.from_obj(obj)
      new(obj["color"], obj["type"], obj["has_moved"])
    end

    def piece_to_s
      return white_piece_char if @color == "w"

      black_piece_char
    end

    def white_piece_char
      return " N " if @type == "knight"
      return "   " if @type == "empty"

      " #{@type[0].upcase} "
    end

    def black_piece_char
      return " N ".colorize(:light_black) if @type == "knight"
      return "   ".colorize(:light_black) if @type == "empty"

      " #{@type[0].upcase} ".colorize(:light_black)
    end
  end
end
