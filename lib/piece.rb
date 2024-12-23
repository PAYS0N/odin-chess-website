# frozen_string_literal: true

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
      return " N " if @type == "knight"
      return "   " if @type == "empty"

      " #{@type[0].upcase} "
    end
  end
end
