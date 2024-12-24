# frozen_string_literal: true

require "colorize"

module OdinChess
  # class that stores piece data
  class Piece
    attr_accessor :color, :has_moved

    def initialize(color, has_moved = false)
      @color = color
      @has_moved = has_moved
    end

    def self.grab_class_from_letter(letter)
      sym_to_class = {
        P: OdinChess::Pawn,
        R: OdinChess::Rook,
        N: OdinChess::Knight,
        B: OdinChess::Bishop,
        K: OdinChess::King,
        Q: OdinChess::Queen
      }
      sym_to_class[letter.to_sym]
    end

    def to_obj
      puts "piece to obj not implemented"
      {}
    end

    def self.from_obj(obj)
      puts "piece from #{obj} not implemented"
    end

    def piece_to_s
      return white_piece_char if @color == "w"

      black_piece_char
    end
  end

  # class for the pawn piece
  class Pawn < Piece
    def white_piece_char
      " P "
    end

    def black_piece_char
      " P ".colorize(:light_black)
    end

    def grab_available_captures(state, move)
      current_cell = [move[1], move[2]]
      shift = @color == "w" ? 1 : -1
      target_cell_right = [current_cell[0] + shift, current_cell[1] + 1]
      target_cell_left = [current_cell[0] + shift, current_cell[1] - 1]
      target_color = @color == "w" ? "b" : "w"
      available_captures = []
      [target_cell_left, target_cell_right].each do |cell|
        available_captures.append(cell) if cell[0].between?(0, 7) &&
                                           cell[1].between?(0, 7) &&
                                           state[cell[0]][cell[1]].color == target_color
      end
      puts "en passent not in"
      available_captures
    end

    def grab_available_moves(state, move)
      current_cell = [move[1], move[2]]
      available_moves = []
      target_cell_one = [current_cell[0] + (@color == "w" ? 1 : -1), current_cell[1]]
      target_cell_two = [current_cell[0] + (@color == "w" ? 2 : -2), current_cell[1]]
      if target_cell_one[0].between?(0, 7) &&
         target_cell_one[1].between?(0, 7) &&
         state[target_cell_one[0]][target_cell_one[1]].is_a?(OdinChess::EmptyPiece)
        available_moves.push(target_cell_one)
      end
      if target_cell_two[0].between?(0, 7) &&
         target_cell_two[1].between?(0, 7) &&
         state[target_cell_two[0]][target_cell_two[1]].is_a?(OdinChess::EmptyPiece) && !@has_moved
        available_moves.push(target_cell_two)
      end
      available_moves
    end
  end

  # class for the rook piece
  class Rook < Piece
    def white_piece_char
      " R "
    end

    def black_piece_char
      " R ".colorize(:light_black)
    end

    def grab_available_captures(state, move)
      cell = [move[1], move[2]]
      target_color = @color == "w" ? "b" : "w"
      available_captures = []
      x = state.length - 1
      y = state[0].length - 1
      available_captures.push(expl_dir_c(state, cell, x - cell[0], 1, 0, target_color))
      available_captures.push(expl_dir_c(state, cell, cell[0], -1, 0, target_color))
      available_captures.push(expl_dir_c(state, cell, y - cell[1], 0, 1, target_color))
      available_captures.push(expl_dir_c(state, cell, cell[1], 0, -1, target_color))
      available_captures
    end

    def grab_available_moves(state, move)
      cell = [move[1], move[2]]
      available_moves = []
      x = state.length - 1
      y = state[0].length - 1
      explore_direction_move(state, cell, x - cell[0], 1, 0).each { |m| available_moves.push(m) } # rubocop:disable Style/MapIntoArray
      explore_direction_move(state, cell, cell[0], -1, 0).each { |m| available_moves.push(m) }
      explore_direction_move(state, cell, y - cell[1], 0, 1).each { |m| available_moves.push(m) }
      explore_direction_move(state, cell, cell[1], 0, -1).each { |m| available_moves.push(m) }
      available_moves
    end

    def expl_dir_c(state, home_cell, times, x_shift, y_shift, target_color)
      times.times do |i|
        x_inc = x_shift <=> 0
        y_inc = y_shift <=> 0
        next_cell = [home_cell[0] + (x_shift * i) + x_inc, home_cell[1] + (y_shift * i) + y_inc]
        next_piece = state[next_cell[0]][next_cell[1]]
        if next_piece.color == target_color
          return next_cell
        elsif next_piece.color == @color
          break
        end
      end
      nil
    end

    def explore_direction_move(state, home_cell, times, x_shift, y_shift)
      available_moves = []
      times.times do |i|
        x_inc = x_shift <=> 0
        y_inc = y_shift <=> 0
        next_cell = [home_cell[0] + (x_shift * i) + x_inc, home_cell[1] + (y_shift * i) + y_inc]
        next_piece = state[next_cell[0]][next_cell[1]]
        break unless next_piece.color == "g"

        available_moves.push(next_cell)
      end
      available_moves
    end
  end

  # class for the knight piece
  class Knight < Piece
    def white_piece_char
      " N "
    end

    def black_piece_char
      " N ".colorize(:light_black)
    end

    def grab_available_captures(state, move)
      current_cell = [move[1], move[2]]
      target_color = @color == "w" ? "b" : "w"
      list = []
      [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]].each do |shift|
        new = [shift[0] + current_cell[0], shift[1] + current_cell[1]]
        list.push(new) if new[0].between?(0, 7) && new[1].between?(0, 7) && state[new[0]][new[1]].color == target_color
      end
      list
    end

    def grab_available_moves(state, move)
      current_cell = [move[1], move[2]]
      list = []
      width = state.length - 1
      height = state[0].length - 1
      [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]].each do |shift|
        new = [shift[0] + current_cell[0], shift[1] + current_cell[1]]
        list.push(new) if new[0].between?(0, width) && new[1].between?(0, height) && state[new[0]][new[1]].color == "g"
      end
      list
    end
  end

  # class for the bishop piece
  class Bishop < Piece
    def white_piece_char
      " B "
    end

    def black_piece_char
      " B ".colorize(:light_black)
    end

    def grab_available_captures(state, move)
      current_cell = [move[1], move[2]]
      target_color = @color == "w" ? "b" : "w"
      available_captures = []
      x = state.length - 1
      y = state[0].length - 1
      top_right = [x - current_cell[0], y - current_cell[1]].min
      top_left = [current_cell[0], y - current_cell[1]].min
      bottom_left = [current_cell[0], current_cell[1]].min
      bottom_right = [x - current_cell[0], current_cell[1]].min
      available_captures.push(explore_direction_capture(state, current_cell, top_right, 1, 1, target_color))
      available_captures.push(explore_direction_capture(state, current_cell, top_left, -1, 1, target_color))
      available_captures.push(explore_direction_capture(state, current_cell, bottom_left, -1, -1, target_color))
      available_captures.push(explore_direction_capture(state, current_cell, bottom_right, 1, -1, target_color))
      available_captures
    end

    def grab_available_moves(state, move)
      current_cell = [move[1], move[2]]
      available_moves = []
      x = state.length - 1
      y = state[0].length - 1
      top_right = [x - current_cell[0], y - current_cell[1]].min
      top_left = [current_cell[0], y - current_cell[1]].min
      bottom_left = [current_cell[0], current_cell[1]].min
      bottom_right = [x - current_cell[0], current_cell[1]].min
      explore_direction_move(state, current_cell, top_right, 1, 1).each { |m| available_moves.push(m) } # rubocop:disable Style/MapIntoArray
      explore_direction_move(state, current_cell, top_left, -1, 1).each { |m| available_moves.push(m) }
      explore_direction_move(state, current_cell, bottom_left, -1, -1).each { |m| available_moves.push(m) }
      explore_direction_move(state, current_cell, bottom_right, 1, -1).each { |m| available_moves.push(m) }
      available_moves
    end

    def explore_direction_capture(state, home_cell, times, x_shift, y_shift, target_color)
      times.times do |i|
        x_inc = x_shift <=> 0
        y_inc = y_shift <=> 0
        next_cell = [home_cell[0] + (x_shift * i) + x_inc, home_cell[1] + (y_shift * i) + y_inc]
        next_piece = state[next_cell[0]][next_cell[1]]
        if next_piece.color == target_color
          return next_cell
        elsif next_piece.color == @color
          break
        end
      end
      nil
    end

    def explore_direction_move(state, home_cell, times, x_shift, y_shift)
      available_moves = []
      times.times do |i|
        x_inc = x_shift <=> 0
        y_inc = y_shift <=> 0
        next_cell = [home_cell[0] + (x_shift * i) + x_inc, home_cell[1] + (y_shift * i) + y_inc]
        next_piece = state[next_cell[0]][next_cell[1]]
        break unless next_piece.color == "g"

        available_moves.push(next_cell)
      end
      available_moves
    end
  end

  # class for the queen piece
  class Queen < Piece
    def white_piece_char
      " Q "
    end

    def black_piece_char
      " Q ".colorize(:light_black)
    end

    def grab_available_captures(state, move)
      current_cell = [move[1], move[2]]
      target_color = @color == "w" ? "b" : "w"
      available_captures = []
      x = state.length - 1
      y = state[0].length - 1
      top_right = [x - current_cell[0], y - current_cell[1]].min
      top_left = [current_cell[0], y - current_cell[1]].min
      bottom_left = [current_cell[0], current_cell[1]].min
      bottom_right = [x - current_cell[0], current_cell[1]].min
      available_captures.push(explore_direction_capture(state, current_cell, top_right, 1, 1, target_color))
      available_captures.push(explore_direction_capture(state, current_cell, top_left, -1, 1, target_color))
      available_captures.push(explore_direction_capture(state, current_cell, bottom_left, -1, -1, target_color))
      available_captures.push(explore_direction_capture(state, current_cell, bottom_right, 1, -1, target_color))
      available_captures.push(explore_direction_capture(state, current_cell, x - current_cell[0], 1, 0, target_color))
      available_captures.push(explore_direction_capture(state, current_cell, current_cell[0], -1, 0, target_color))
      available_captures.push(explore_direction_capture(state, current_cell, y - current_cell[1], 0, 1, target_color))
      available_captures.push(explore_direction_capture(state, current_cell, current_cell[1], 0, -1, target_color))
      available_captures
    end

    def grab_available_moves(state, move)
      current_cell = [move[1], move[2]]
      available_moves = []
      x = state.length - 1
      y = state[0].length - 1
      top_right = [x - current_cell[0], y - current_cell[1]].min
      top_left = [current_cell[0], y - current_cell[1]].min
      bottom_left = [current_cell[0], current_cell[1]].min
      bottom_right = [x - current_cell[0], current_cell[1]].min
      explore_direction_move(state, current_cell, top_right, 1, 1).each { |m| available_moves.push(m) } # rubocop:disable Style/MapIntoArray
      explore_direction_move(state, current_cell, top_left, -1, 1).each { |m| available_moves.push(m) }
      explore_direction_move(state, current_cell, bottom_left, -1, -1).each { |m| available_moves.push(m) }
      explore_direction_move(state, current_cell, bottom_right, 1, -1).each { |m| available_moves.push(m) }
      explore_direction_move(state, current_cell, x - current_cell[0], 1, 0).each { |m| available_moves.push(m) }
      explore_direction_move(state, current_cell, current_cell[0], -1, 0).each { |m| available_moves.push(m) }
      explore_direction_move(state, current_cell, y - current_cell[1], 0, 1).each { |m| available_moves.push(m) }
      explore_direction_move(state, current_cell, current_cell[1], 0, -1).each { |m| available_moves.push(m) }
      available_moves
    end

    def explore_direction_capture(state, home_cell, times, x_shift, y_shift, target_color)
      times.times do |i|
        x_inc = x_shift <=> 0
        y_inc = y_shift <=> 0
        next_cell = [home_cell[0] + (x_shift * i) + x_inc, home_cell[1] + (y_shift * i) + y_inc]
        next_piece = state[next_cell[0]][next_cell[1]]
        if next_piece.color == target_color
          return next_cell
        elsif next_piece.color == @color
          break
        end
      end
      nil
    end

    def explore_direction_move(state, home_cell, times, x_shift, y_shift)
      available_moves = []
      times.times do |i|
        x_inc = x_shift <=> 0
        y_inc = y_shift <=> 0
        next_cell = [home_cell[0] + (x_shift * i) + x_inc, home_cell[1] + (y_shift * i) + y_inc]
        next_piece = state[next_cell[0]][next_cell[1]]
        break unless next_piece.color == "g"

        available_moves.push(next_cell)
      end
      available_moves
    end
  end

  # class for the king piece
  class King < Piece
    def white_piece_char
      " K "
    end

    def black_piece_char
      " K ".colorize(:light_black)
    end

    def grab_available_captures(state, move)
      current_cell = [move[1], move[2]]
      target_color = @color == "w" ? "b" : "w"
      available_captures = []
      [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |dir|
        target_cell = [current_cell[0] + dir[0], current_cell[1] + dir[1]]
        next unless target_cell[0].between?(0, 7) && target_cell[1].between?(0, 7)

        target_piece = state[target_cell[0]][target_cell[1]]
        available_captures.push(target_cell) if target_piece.color == target_color
      end
      available_captures
    end

    def grab_available_moves(state, move)
      current_cell = [move[1], move[2]]
      available_moves = []
      [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |dir|
        target_cell = [current_cell[0] + dir[0], current_cell[1] + dir[1]]
        next unless target_cell[0].between?(0, 7) && target_cell[1].between?(0, 7)

        target_piece = state[target_cell[0]][target_cell[1]]
        available_moves.push(target_cell) if target_piece.color == "g"
      end
      available_moves
    end
  end

  # class to signify no piece on the board
  class EmptyPiece < Piece
    def white_piece_char
      "   "
    end

    def black_piece_char
      "   ".colorize(:light_black)
    end

    def grab_available_captures(_state, _move)
      []
    end
  end
end
