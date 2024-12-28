# frozen_string_literal: true

require_relative("piece")
require_relative("move")

require "json"

# module to store chess game
module OdinChess
  # class to store game state and logic
  class GameBoard
    attr_reader :game_ended, :game_state, :active_color, :active_player

    def initialize(player1, player2, player_1_is_active, game_state = [])
      @player1 = player1
      @player2 = player2
      @active_player = player_1_is_active ? @player1 : @player2
      @active_color = @active_player == @player1 ? "w" : "b"
      @game_ended = false
      @game_state = game_state
      @in_check = { w: false, b: false }
      return unless @game_state == []

      8.times do
        @game_state.push([])
      end
      setup_game_state
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

    def swap_actives
      @active_color = (@active_color == "b" ? "w" : "b")
      @active_player = (@active_player == @player1 ? @player2 : @player1)
    end

    def apply_move(move)
      return castle(move) if ["Castle", "Long castle"].include?(move.type)

      save_pieces(move)
      update_pieces(move)
    end

    def save_pieces(move)
      @original_piece = @game_state[move.row][move.col]
      @original_target = @game_state[move.target_row][move.target_col]
    end

    def update_pieces(move)
      @game_state[move.target_row][move.target_col] = move.p_class.new(@active_color)
      @game_state[move.target_row][move.target_col].has_moved = true
      @game_state[move.row][move.col] = OdinChess::EmptyPiece.new("g")
    end

    def unapply_move(move)
      return uncastle(move) if ["Castle", "Long castle"].include?(move.type)

      @game_state[move.row][move.col] = @original_piece
      @game_state[move.target_row][move.target_col] = @original_target
    end

    def castle(move)
      @active_color == "w" ? white_castle(move) : black_castle(move)
    end

    def white_castle(move)
      move.type == "Castle" ? white_short_castle : white_long_castle
    end

    def black_castle(move)
      move.type == "Castle" ? black_short_castle : black_long_castle
    end

    def uncastle(move)
      @active_color == "w" ? unwhite_castle(move) : unblack_castle(move)
    end

    def unwhite_castle(move)
      move.type == "Castle" ? unwhite_short_castle : unwhite_long_castle
    end

    def unblack_castle(move)
      move.type == "Castle" ? unblack_short_castle : unblack_long_castle
    end

    def white_short_castle
      @game_state[0][4] = EmptyPiece.new("g")
      @game_state[0][5] = Rook.new("w")
      @game_state[0][5].has_moved = true
      @game_state[0][6] = King.new("w")
      @game_state[0][6].has_moved = true
      @game_state[0][7] = EmptyPiece.new("g")
    end

    def white_long_castle
      @game_state[0][4] = EmptyPiece.new("g")
      @game_state[0][3] = Rook.new("w")
      @game_state[0][3].has_moved = true
      @game_state[0][2] = King.new("w")
      @game_state[0][2].has_moved = true
      @game_state[0][1] = EmptyPiece.new("g")
      @game_state[0][0] = EmptyPiece.new("g")
    end

    def black_short_castle
      @game_state[7][4] = EmptyPiece.new("g")
      @game_state[7][5] = Rook.new("b")
      @game_state[7][5].has_moved = true
      @game_state[7][6] = King.new("b")
      @game_state[7][6].has_moved = true
      @game_state[7][7] = EmptyPiece.new("g")
    end

    def black_long_castle
      @game_state[7][4] = EmptyPiece.new("g")
      @game_state[7][3] = Rook.new("b")
      @game_state[7][3].has_moved = true
      @game_state[7][2] = King.new("b")
      @game_state[7][2].has_moved = true
      @game_state[7][1] = EmptyPiece.new("g")
      @game_state[7][0] = EmptyPiece.new("g")
    end

    def unwhite_short_castle
      @game_state[0][4] = King.new("w")
      @game_state[0][5] = EmptyPiece.new("g")
      @game_state[0][6] = EmptyPiece.new("g")
      @game_state[0][7] = Rook.new("w")
    end

    def unwhite_long_castle
      @game_state[0][4] = King.new("w")
      @game_state[0][3] = EmptyPiece.new("g")
      @game_state[0][2] = EmptyPiece.new("g")
      @game_state[0][1] = EmptyPiece.new("g")
      @game_state[0][0] = Rook.new("w")
    end

    def unblack_short_castle
      @game_state[7][4] = King.new("b")
      @game_state[7][5] = EmptyPiece.new("g")
      @game_state[7][6] = EmptyPiece.new("g")
      @game_state[7][7] = Rook.new("b")
    end

    def unblack_long_castle
      @game_state[7][4] = King.new("b")
      @game_state[7][3] = EmptyPiece.new("g")
      @game_state[7][2] = EmptyPiece.new("g")
      @game_state[7][1] = EmptyPiece.new("g")
      @game_state[7][0] = Rook.new("b")
    end

    def valid?(move)
      check_technically_valid(move) && check_logically_valid(move)
    end

    def check_technically_valid(move)
      return true if ["Castle", "Long castle"].include?(move.type)
      return false if move.type == "Invalid"

      move.technically_valid?
    end

    def check_logically_valid(move)
      if ["Castle", "Long castle"].include?(move.type)
        castle_valid?(move.type)
      else
        piece_at_cell(move.p_class, [move.row, move.col]) &&
          piece_correct_color([move.row, move.col]) &&
          target_cell_ok([move.target_row, move.target_col], move.is_capture) &&
          piece_can_move(move) &&
          move_doesnt_lose(move)
      end
    end

    def piece_at_cell(piece_class, cell)
      passes = @game_state[cell[0]][cell[1]].is_a?(piece_class)
      unless passes
        puts "The piece you indicated #{piece_class} is not at that starting cell [#{cell[0]}, #{cell[1]}]. #{@game_state[cell[0]][cell[1]].piece_to_s.strip} is."
      end
      passes
    end

    def piece_correct_color(cell)
      passes = @game_state[cell[0]][cell[1]].color == @active_color
      puts "The piece you indicated is not yours." unless passes
      passes
    end

    def target_cell_ok(cell, move_is_capture)
      unless move_is_capture
        passes = @game_state[cell[0]][cell[1]].is_a?(EmptyPiece)
        puts "That cell is occupied by #{@game_state[cell[0]][cell[1]]}." unless passes

        return passes
      end

      target_color = @active_color == "w" ? "b" : "w"
      passes = @game_state[cell[0]][cell[1]].color == target_color
      puts "You can only take #{target_color} pieces." unless passes
      passes
    end

    def piece_can_move(move)
      cells = if move.is_capture
                @game_state[move.row][move.col].grab_available_captures(@game_state, [move.row, move.col])
              else
                @game_state[move.row][move.col].grab_available_moves(@game_state, [move.row, move.col])
              end
      passes = cells.include?([move.target_row, move.target_col])
      puts "That piece can only go to #{cells.inspect}." unless passes
      passes
    end

    def move_doesnt_lose(move)
      @in_check = update_check(move)
      turn_color_sym = @active_color.to_sym
      puts "Check." if !@in_check[turn_color_sym] && @in_check[turn_color_sym == :w ? :b : :w]
      !@in_check[turn_color_sym]
    end

    def update_check(move)
      apply_move(move)
      possible_captures_white = []
      possible_captures_black = []
      white_king = []
      black_king = []
      @game_state.each_with_index do |row, i|
        row.each_with_index do |piece, j|
          if piece.color == "w"
            white_king = [i, j] if piece.is_a?(King)
          elsif piece.is_a?(King)
            black_king = [i, j]
          end
          piece.grab_available_captures(@game_state, [i, j]).each do |capture|
            if piece.color == "w"
              possible_captures_white.append(capture)
            else
              possible_captures_black.append(capture)
            end
          end
        end
      end
      unapply_move(move)
      { w: possible_captures_black.include?(white_king), b: possible_captures_white.include?(black_king) }
    end

    def castle_valid?(type)
      if type == "Castle"
        if @active_color == "w"
          white_short_castle_valid?
        else
          black_short_castle_valid?
        end
      elsif @active_color == "w"
        white_long_castle_valid?
      else
        black_long_castle_valid?
      end
    end

    def white_short_castle_valid?
      @game_state[0][4].is_a?(King) && !@game_state[0][4].has_moved &&
        @game_state[0][5].is_a?(EmptyPiece) &&
        @game_state[0][6].is_a?(EmptyPiece) &&
        @game_state[0][7].is_a?(Rook) && !@game_state[0][7].has_moved
    end

    def black_short_castle_valid?
      @game_state[7][4].is_a?(King) && !@game_state[7][4].has_moved &&
        @game_state[7][5].is_a?(EmptyPiece) &&
        @game_state[7][6].is_a?(EmptyPiece) &&
        @game_state[7][7].is_a?(Rook) && !@game_state[7][7].has_moved
    end

    def white_long_castle_valid?
      @game_state[0][0].is_a?(Rook) && !@game_state[0][0].has_moved &&
        @game_state[0][1].is_a?(EmptyPiece) &&
        @game_state[0][2].is_a?(EmptyPiece) &&
        @game_state[0][3].is_a?(EmptyPiece) &&
        @game_state[0][4].is_a?(King) && !@game_state[0][4].has_moved
    end

    def black_long_castle_valid?
      @game_state[7][0].is_a?(Rook) && !@game_state[7][0].has_moved &&
        @game_state[7][1].is_a?(EmptyPiece) &&
        @game_state[7][2].is_a?(EmptyPiece) &&
        @game_state[7][3].is_a?(EmptyPiece) &&
        @game_state[7][4].is_a?(King) && !@game_state[7][4].has_moved
    end

    def check_game_over
      @game_ended = true
      @game_state.each_with_index do |row, i|
        row.each_with_index do |piece, j|
          next unless piece.color == @active_color

          if check_all_moves(piece, @active_color, i, j) || check_all_captures(piece, @active_color, i, j)
            @game_ended = false
          end
        end
      end
    end

    def check_all_moves(piece, color, row, col)
      move_cells = piece.grab_available_moves(@game_state, [row, col]).compact
      move_cells.each do |cell|
        move = OdinChess::Move.new("Normal", piece.class, [row, col], cell, false)
        return true unless update_check(move)[color.to_sym]
      end
      false
    end

    def check_all_captures(piece, color, row, col)
      capt_cells = piece.grab_available_captures(@game_state, [row, col]).compact
      capt_cells.each do |cell|
        move = OdinChess::Move.new("Normal", piece.class, [row, col], cell, true)
        return true unless update_check(move)[color.to_sym]
      end
      false
    end
  end
end
