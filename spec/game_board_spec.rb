# frozen_string_literal: true

require_relative("../lib/game_board")
require_relative("../lib/move")

describe OdinChess::GameBoard do
  describe "#piece_at_cell" do
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    subject(:board_piece_logic) { described_class.new(player1, player2, true) }
    context "when game_state is unchanged" do
      before do
        allow_any_instance_of(Kernel).to receive(:puts)
      end
      context "when given valid pairs" do
        [[OdinChess::Pawn, [1, 0]], [OdinChess::Pawn, [6, 5]], [OdinChess::Rook, [0, 0]], [OdinChess::Rook, [7, 7]], [OdinChess::Queen, [0, 3]]].each do |input|
          it "returns true for #{input.inspect}" do
            check = board_piece_logic.piece_at_cell(input[0], input[1])
            expect(check).to be_truthy
          end
        end
      end
      context "when given invalid moves" do
        [[OdinChess::Rook, [0, 1]], [OdinChess::Queen, [0, 1]], [OdinChess::Pawn, [4, 4]]].each do |input|
          it "returns false for #{input.inspect}" do
            check = board_piece_logic.piece_at_cell(input[0], input[1])
            expect(check).to be_falsy
          end
        end
      end
    end
  end

  describe "#target_cell_ok" do
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    subject(:board_target) { described_class.new(player1, player2, true) }
    context "when game_state is unchanged" do
      before do
        allow_any_instance_of(Kernel).to receive(:puts)
      end
      context "when moving to empty cell" do
        [[2, 0], [5, 2], [4, 4], [5, 4]].each do |input|
          it "returns true for #{input.inspect}" do
            check = board_target.target_cell_ok(input, false)
            expect(check).to be_truthy
          end
        end
      end
      context "when capturing to empty cell" do
        [[[2, 0], true], [[5, 2], true], [[4, 4], true]].each do |input|
          it "returns false for #{input.inspect}" do
            check = board_target.target_cell_ok(input[0], input[1])
            expect(check).to be_falsy
          end
        end
      end
      context "when white is capturing to tile with black" do
        [[[7, 4], true], [[6, 2], true], [[7, 4], true]].each do |input|
          it "returns true for #{input.inspect}" do
            check = board_target.target_cell_ok(input[0], input[1])
            expect(check).to be_truthy
          end
        end
      end
      context "when white is capturing to tile with white" do
        [[[1, 4], true], [[1, 2], true], [[0, 4], true]].each do |input|
          it "returns false for #{input.inspect}" do
            check = board_target.target_cell_ok(input[0], input[1])
            expect(check).to be_falsy
          end
        end
      end
      context "when black is capturing to tile with black" do
        before do
          board_target.instance_variable_set(:@active_color, "b")
        end
        [[[7, 4], true], [[6, 2], true], [[7, 4], true]].each do |input|
          it "returns false for #{input.inspect}" do
            check = board_target.target_cell_ok(input[0], input[1])
            expect(check).to be_falsy
          end
        end
      end
      context "when black is capturing to tile with white" do
        before do
          board_target.instance_variable_set(:@active_color, "b")
        end
        [[[1, 4], true], [[1, 2], true], [[0, 4], true]].each do |input|
          it "returns true for #{input.inspect}" do
            check = board_target.target_cell_ok(input[0], input[1])
            expect(check).to be_truthy
          end
        end
      end
    end
  end

  describe "pawn two move tracking" do
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    subject(:board_pawns) { described_class.new(player1, player2, true) }

    context "when state is at beginning" do
      [[1, 1], [1, 6], [6, 4], [6, 7]].each do |input|
        it "piece at #{input.inspect} is a pawn" do
          is_pawn = board_pawns.game_state[input[0]][input[1]].is_a?(OdinChess::Pawn)
          expect(is_pawn).to be_truthy
        end
        it "pawn has not moved" do
          has_moved = board_pawns.game_state[input[0]][input[1]].has_moved
          expect(has_moved).to be_falsy
        end
        it "pawn has not double moved" do
          has_moved = board_pawns.game_state[input[0]][input[1]].just_two_moved
          expect(has_moved).to be_falsy
        end
      end
    end

    context "after a pawn double move" do
      before do
        move = OdinChess::Move.from_string("e2e4")
        board_pawns.valid?(move)
        board_pawns.apply_move(move)
      end
      it "pawn moved to cell" do
        is_pawn = board_pawns.game_state[3][4].is_a?(OdinChess::Pawn)
        expect(is_pawn).to be_truthy
      end
      it "pawn has moved" do
        has_moved = board_pawns.game_state[3][4].has_moved
        expect(has_moved).to be_truthy
      end
      it "pawn has double moved" do
        two_moved = board_pawns.game_state[3][4].just_two_moved
        expect(two_moved).to be_truthy
      end
    end

    context "after the pawn moves twice" do
      before do
        move = OdinChess::Move.from_string("e2e4")
        board_pawns.valid?(move)
        board_pawns.apply_move(move)
        board_pawns.update_pawns
        move = OdinChess::Move.from_string("e4e5")
        board_pawns.valid?(move)
        board_pawns.apply_move(move)
        board_pawns.update_pawns
      end
      it "pawn moved to cell" do
        is_pawn = board_pawns.game_state[4][4].is_a?(OdinChess::Pawn)
        expect(is_pawn).to be_truthy
      end
      it "pawn has moved" do
        has_moved = board_pawns.game_state[4][4].has_moved
        expect(has_moved).to be_truthy
      end
      it "pawn did not just double move" do
        two_moved = board_pawns.game_state[4][4].just_two_moved
        expect(two_moved).to be_falsy
      end
    end

    context "after the pawn moves, then a enemy piece moves" do
      before do
        move = OdinChess::Move.from_string("e2e4")
        board_pawns.valid?(move)
        board_pawns.apply_move(move)
        board_pawns.post_move_updates
        move = OdinChess::Move.from_string("e7e6")
        board_pawns.valid?(move)
        board_pawns.apply_move(move)
        board_pawns.post_move_updates
      end
      it "pawn unmoved" do
        is_pawn = board_pawns.game_state[3][4].is_a?(OdinChess::Pawn)
        expect(is_pawn).to be_truthy
      end
      it "pawn has moved" do
        has_moved = board_pawns.game_state[3][4].has_moved
        expect(has_moved).to be_truthy
      end
      it "pawn did not just double move" do
        two_moved = board_pawns.game_state[3][4].just_two_moved
        expect(two_moved).to be_falsy
      end
    end

    context "after the pawn moves, then a different piece moves" do
      before do
        move = OdinChess::Move.from_string("e2e4")
        board_pawns.valid?(move)
        board_pawns.apply_move(move)
        board_pawns.update_pawns
        move = OdinChess::Move.from_string("d2d4")
        board_pawns.valid?(move)
        board_pawns.apply_move(move)
        board_pawns.post_move_updates
      end
      it "other pawn moved to cell" do
        is_pawn = board_pawns.game_state[3][3].is_a?(OdinChess::Pawn)
        expect(is_pawn).to be_truthy
      end
      it "pawn has moved" do
        has_moved = board_pawns.game_state[3][4].has_moved
        expect(has_moved).to be_truthy
      end
      it "pawn did not just double move" do
        two_moved = board_pawns.game_state[3][4].just_two_moved
        expect(two_moved).to be_falsy
      end
    end
  end

  describe "short castling" do
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    subject(:board_rooks) { described_class.new(player1, player2, true) }

    context "when state is at beginning" do
      [[0, 0], [7, 7], [0, 4], [7, 4]].each do |input|
        it "piece at #{input.inspect} has not moved" do
          has_moved = board_rooks.game_state[input[0]][input[1]].has_moved
          expect(has_moved).to be_falsy
        end
      end
    end

    context "after pieces clear, castle works" do
      before do
        move = OdinChess::Move.from_string("e2e4")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Bf1c4")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Ng1f3")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
      end
      it "can castle" do
        move = OdinChess::Move.from_string("0-0")
        expect(board_rooks.valid?(move)).to be_truthy
      end
      it "rook in correct spot" do
        move = OdinChess::Move.from_string("0-0")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        expect(board_rooks.game_state[0][5]).to be_a(OdinChess::Rook)
      end
      it "king in correct spot" do
        move = OdinChess::Move.from_string("0-0")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        expect(board_rooks.game_state[0][6]).to be_a(OdinChess::King)
      end
    end

    context "after pieces clear, rook moves, castle doesnt work" do
      before do
        move = OdinChess::Move.from_string("e2e4")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Bf1c4")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Ng1f3")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Rh1g1")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Rg1h1")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
      end
      it "has rook with has_moved" do
        expect(board_rooks.game_state[0][7].has_moved).to be_truthy
      end
      it "can't castle" do
        move = OdinChess::Move.from_string("0-0")
        expect(board_rooks.valid?(move)).to be_falsy
      end
    end

    context "after pieces clear, king moves, castle doesnt work" do
      before do
        move = OdinChess::Move.from_string("e2e4")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Bf1c4")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Ng1f3")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Ke1f1")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Kf1e1")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
      end
      it "has king with has_moved" do
        expect(board_rooks.game_state[0][4].has_moved).to be_truthy
      end
      it "can't castle" do
        move = OdinChess::Move.from_string("0-0")
        expect(board_rooks.valid?(move)).to be_falsy
      end
    end
    context "after pieces clear, black castle works" do
      before do
        board_rooks.swap_actives
        move = OdinChess::Move.from_string("e7e5")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Bf8c5")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        move = OdinChess::Move.from_string("Ng8f6")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
      end
      it "can castle" do
        move = OdinChess::Move.from_string("0-0")
        expect(board_rooks.valid?(move)).to be_truthy
      end
      it "rook in correct spot" do
        move = OdinChess::Move.from_string("0-0")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        expect(board_rooks.game_state[7][5]).to be_a(OdinChess::Rook)
      end
      it "king in correct spot" do
        move = OdinChess::Move.from_string("0-0")
        board_rooks.valid?(move)
        board_rooks.apply_move(move)
        expect(board_rooks.game_state[7][6]).to be_a(OdinChess::King)
      end
    end
  end

  describe "long castling" do
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    subject(:board_long) { described_class.new(player1, player2, true) }

    context "when state is at beginning" do
      [[0, 0], [7, 7], [0, 4], [7, 4]].each do |input|
        it "piece at #{input.inspect} has not moved" do
          has_moved = board_long.game_state[input[0]][input[1]].has_moved
          expect(has_moved).to be_falsy
        end
      end
    end

    context "after pieces clear, castle works" do
      before do
        move = OdinChess::Move.from_string("d2d4")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Bc1e3")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Nb1c3")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Qd1d2")
        board_long.valid?(move)
        board_long.apply_move(move)
      end
      it "can castle" do
        move = OdinChess::Move.from_string("0-0-0")
        expect(board_long.valid?(move)).to be_truthy
      end
      it "rook in correct spot" do
        move = OdinChess::Move.from_string("0-0-0")
        board_long.valid?(move)
        board_long.apply_move(move)
        expect(board_long.game_state[0][3]).to be_a(OdinChess::Rook)
      end
      it "king in correct spot" do
        move = OdinChess::Move.from_string("0-0-0")
        board_long.valid?(move)
        board_long.apply_move(move)
        expect(board_long.game_state[0][2]).to be_a(OdinChess::King)
      end
    end

    context "after pieces clear, rook moves, castle doesnt work" do
      before do
        move = OdinChess::Move.from_string("d2d4")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Bc1e3")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Nb1c3")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Qd1d2")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Ra1b1")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Rb1a1")
        board_long.valid?(move)
        board_long.apply_move(move)
      end
      it "has rook with has_moved" do
        expect(board_long.game_state[0][0].has_moved).to be_truthy
      end
      it "can't castle" do
        move = OdinChess::Move.from_string("0-0-0")
        expect(board_long.valid?(move)).to be_falsy
      end
    end

    context "after pieces clear, king moves, castle doesnt work" do
      before do
        move = OdinChess::Move.from_string("d2d4")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Bc1e3")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Nb1c3")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Qd1d2")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Ke1d1")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Kd1e1")
        board_long.valid?(move)
        board_long.apply_move(move)
      end
      it "has king with has_moved" do
        expect(board_long.game_state[0][4].has_moved).to be_truthy
      end
      it "can't castle" do
        move = OdinChess::Move.from_string("0-0-0")
        expect(board_long.valid?(move)).to be_falsy
      end
    end
    context "after pieces clear, black castle works" do
      before do
        board_long.swap_actives
        move = OdinChess::Move.from_string("d7d5")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Bc8f5")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Nb8c6")
        board_long.valid?(move)
        board_long.apply_move(move)
        move = OdinChess::Move.from_string("Qd8d7")
        board_long.valid?(move)
        board_long.apply_move(move)
      end
      it "can castle" do
        move = OdinChess::Move.from_string("0-0-0")
        expect(board_long.valid?(move)).to be_truthy
      end
      it "rook in correct spot" do
        move = OdinChess::Move.from_string("0-0-0")
        board_long.valid?(move)
        board_long.apply_move(move)
        expect(board_long.game_state[7][3]).to be_a(OdinChess::Rook)
      end
      it "king in correct spot" do
        move = OdinChess::Move.from_string("0-0-0")
        board_long.valid?(move)
        board_long.apply_move(move)
        expect(board_long.game_state[7][2]).to be_a(OdinChess::King)
      end
    end
  end
end
