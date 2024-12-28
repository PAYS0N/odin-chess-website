# frozen_string_literal: true

require "json"

module OdinChess
  # class that stores player name
  class Player
    attr_accessor :name, :color

    def initialize(name = nil, color = nil)
      @name = name
      @name = color
    end
  end
end
