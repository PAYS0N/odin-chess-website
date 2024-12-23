# frozen_string_literal: true

require "json"

# module to store chess game
module OdinChess
  # class that stores player name
  class Player
    attr_accessor :name, :active

    def initialize(name = nil, active = false)
      @name = name
      @active = active
    end

    def to_obj
      { name: @name, active: @active }
    end

    def self.from_obj(obj)
      new(obj["name"], obj["active"])
    end
  end
end
