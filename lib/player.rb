# frozen_string_literal: true

require "json"

# module to store chess game
module OdinChess
  # class that stores player name
  class Player
    attr_accessor :name, :active, :color

    def initialize(name = nil, active = false, color = nil)
      @name = name
      @active = active
      @color = color
    end

    def to_obj
      { name: @name, active: @active, color: @color }
    end

    def self.from_obj(obj)
      new(obj["name"], obj["active"], obj["color"])
    end

    def swap_active
      @active = !@active
    end
  end
end
