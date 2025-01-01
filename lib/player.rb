# frozen_string_literal: true

module OdinChess
  # class that stores player name
  class Player
    attr_accessor :name, :color

    def initialize(name = nil, color = nil)
      @name = name
      @color = color
    end

    def to_obj
      { name: @name, color: @color }
    end

    def self.from_obj(obj)
      new(obj["name"], obj["color"])
    end
  end
end
