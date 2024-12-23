# frozen_string_literal: true

# module to store chess game
module OdinChess
  # class that stores piece data
  class Piece
    attr_accessor :color, :has_moved, :type

    def initialize(color, type)
      @color = color
      @has_moved = false
      @type = type
    end
  end
end
