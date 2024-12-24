# frozen_string_literal: true

require_relative("../lib/piece")
require_relative("../lib/game_board")

describe OdinChess::Pawn do
  describe "#grab_available_moves, #grab_available_captures" do
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    let(:state) do
      [[OdinChess::EmptyPiece.new("g"), OdinChess::Pawn.new("w"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::Queen.new("b")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")]]
    end
    subject(:board_for_pawn) { OdinChess::GameBoard.new(player1, player2, state) }
    let(:board_pawn) { board_for_pawn.game_state[0][1] }
    context "when board set up with two diagonal opposing pieces" do
      it "can move forward one" do
        expect(board_pawn.grab_available_moves(board_for_pawn.game_state, [0, 0, 1])).to include([1, 1])
      end
      it "can move forward two" do
        expect(board_pawn.grab_available_moves(board_for_pawn.game_state, [0, 0, 1])).to include([2, 1])
      end
      it "can't move illegally" do
        expect(board_pawn.grab_available_moves(board_for_pawn.game_state, [0, 0, 1])).to_not include([2, 2])
      end
      it "can take foward left" do
        expect(board_pawn.grab_available_captures(board_for_pawn.game_state, [0, 0, 1])).to include([1, 0])
      end
      it "can take forward right" do
        expect(board_pawn.grab_available_captures(board_for_pawn.game_state, [0, 0, 1])).to include([1, 2])
      end
      it "can't take 2 forward left" do
        expect(board_pawn.grab_available_captures(board_for_pawn.game_state, [0, 0, 1])).to_not include([2, 2])
      end
    end
  end
end

describe OdinChess::Rook do
  describe "#grab_available_moves, #grab_available_captures" do
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    let(:state) do
      [[OdinChess::EmptyPiece.new("g"), OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::Rook.new("w"), OdinChess::Queen.new("b")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")]]
    end
    subject(:board_for_rook) { OdinChess::GameBoard.new(player1, player2, state) }
    let(:board_rook) { board_for_rook.game_state[1][1] }
    context "when board set up with three opposing pieces" do
      it "can move forward one" do
        expect(board_rook.grab_available_moves(board_for_rook.game_state, [0, 1, 1])).to include([2, 1])
      end
      it "can move forward two" do
        expect(board_rook.grab_available_moves(board_for_rook.game_state, [0, 1, 1])).to include([3, 1])
      end
      it "can't move diagonal" do
        expect(board_rook.grab_available_moves(board_for_rook.game_state, [0, 1, 1])).to_not include([0, 0])
      end
      it "can take left" do
        expect(board_rook.grab_available_captures(board_for_rook.game_state, [0, 1, 1])).to include([1, 0])
      end
      it "can take right" do
        expect(board_rook.grab_available_captures(board_for_rook.game_state, [0, 1, 1])).to include([1, 2])
      end
      it "can take down" do
        expect(board_rook.grab_available_captures(board_for_rook.game_state, [0, 1, 1])).to include([0, 1])
      end
      it "can't take forward left" do
        expect(board_rook.grab_available_captures(board_for_rook.game_state, [0, 1, 1])).to_not include([2, 2])
      end
    end
  end
end

describe OdinChess::Knight do
  describe "#grab_available_moves, #grab_available_captures" do
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    let(:state) do
      [[OdinChess::EmptyPiece.new("g"), OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::Rook.new("b"), OdinChess::Queen.new("b"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::Knight.new("w"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::Rook.new("b"), OdinChess::EmptyPiece.new("g")]]
    end
    subject(:board_for_knight) { OdinChess::GameBoard.new(player1, player2, state) }
    let(:board_knight) { board_for_knight.game_state[2][1] }
    context "when board set up with three opposing pieces" do
      it "can move legally" do
        expect(board_knight.grab_available_moves(board_for_knight.game_state, [0, 2, 1])).to include([0, 0])
      end
      it "can move legally" do
        expect(board_knight.grab_available_moves(board_for_knight.game_state, [0, 2, 1])).to include([0, 2])
      end
      it "can move legally" do
        expect(board_knight.grab_available_moves(board_for_knight.game_state, [0, 2, 1])).to include([3, 3])
      end
      it "can move legally" do
        expect(board_knight.grab_available_moves(board_for_knight.game_state, [0, 2, 1])).to include([0, 2])
      end
      it "can't move illegally" do
        expect(board_knight.grab_available_moves(board_for_knight.game_state, [0, 2, 1])).to_not include([4, 0])
      end
      it "can't move illegally" do
        expect(board_knight.grab_available_moves(board_for_knight.game_state, [0, 2, 1])).to_not include([0, 1])
      end
      it "can take legally" do
        expect(board_knight.grab_available_captures(board_for_knight.game_state, [0, 2, 1])).to include([4, 0])
      end
      it "can take legally" do
        expect(board_knight.grab_available_captures(board_for_knight.game_state, [0, 2, 1])).to include([4, 2])
      end
      it "can't take illegally" do
        expect(board_knight.grab_available_captures(board_for_knight.game_state, [0, 2, 1])).to_not include([1, 1])
      end
    end
  end
end

describe OdinChess::Bishop do
  describe "#grab_available_moves, #grab_available_captures" do
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    let(:state) do
      [[OdinChess::EmptyPiece.new("g"), OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::Bishop.new("w"), OdinChess::Queen.new("b")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")]]
    end
    subject(:board_for_bishop) { OdinChess::GameBoard.new(player1, player2, state) }
    let(:board_bishop) { board_for_bishop.game_state[1][1] }
    context "when board set up with three opposing pieces" do
      it "can move legally" do
        expect(board_bishop.grab_available_moves(board_for_bishop.game_state, [0, 1, 1])).to include([0, 0])
      end
      it "can move legally" do
        expect(board_bishop.grab_available_moves(board_for_bishop.game_state, [0, 1, 1])).to include([0, 2])
      end
      it "can move legally" do
        expect(board_bishop.grab_available_moves(board_for_bishop.game_state, [0, 1, 1])).to include([2, 2])
      end
      it "can't move illegally" do
        expect(board_bishop.grab_available_moves(board_for_bishop.game_state, [0, 1, 1])).to_not include([2, 1])
      end
      it "can't move illegally" do
        expect(board_bishop.grab_available_moves(board_for_bishop.game_state, [0, 1, 1])).to_not include([1, 2])
      end
      it "can take legally" do
        expect(board_bishop.grab_available_captures(board_for_bishop.game_state, [0, 1, 1])).to include([2, 0])
      end
      it "can't take illegally" do
        expect(board_bishop.grab_available_captures(board_for_bishop.game_state, [0, 1, 1])).to_not include([3, 0])
      end
    end
  end
end

describe OdinChess::Queen do
  describe "#grab_available_moves, #grab_available_captures" do
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    let(:state) do
      [[OdinChess::EmptyPiece.new("g"), OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::Queen.new("w"), OdinChess::Queen.new("b")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")]]
    end
    subject(:board_for_queen) { OdinChess::GameBoard.new(player1, player2, state) }
    let(:board_queen) { board_for_queen.game_state[1][1] }
    context "when board set up with three opposing pieces" do
      it "can move legally" do
        expect(board_queen.grab_available_moves(board_for_queen.game_state, [0, 1, 1])).to include([0, 0])
      end
      it "can move legally" do
        expect(board_queen.grab_available_moves(board_for_queen.game_state, [0, 1, 1])).to include([3, 1])
      end
      it "can move legally" do
        expect(board_queen.grab_available_moves(board_for_queen.game_state, [0, 1, 1])).to include([2, 2])
      end
      it "can't move illegally" do
        expect(board_queen.grab_available_moves(board_for_queen.game_state, [0, 1, 1])).to_not include([3, 0])
      end
      it "can't move illegally" do
        expect(board_queen.grab_available_moves(board_for_queen.game_state, [0, 1, 1])).to_not include([0, 1])
      end
      it "can take legally" do
        expect(board_queen.grab_available_captures(board_for_queen.game_state, [0, 1, 1])).to include([0, 1])
      end
      it "can't take illegally" do
        expect(board_queen.grab_available_captures(board_for_queen.game_state, [0, 1, 1])).to_not include([3, 0])
      end
    end
  end
end

describe OdinChess::King do
  describe "#grab_available_moves, #grab_available_captures" do
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    let(:state) do
      [[OdinChess::EmptyPiece.new("g"), OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::King.new("w"), OdinChess::Queen.new("b")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")],
       [OdinChess::Pawn.new("b"), OdinChess::EmptyPiece.new("g"), OdinChess::EmptyPiece.new("g")]]
    end
    subject(:board_for_king) { OdinChess::GameBoard.new(player1, player2, state) }
    let(:board_king) { board_for_king.game_state[1][1] }
    context "when board set up with three opposing pieces" do
      it "can move legally" do
        expect(board_king.grab_available_moves(board_for_king.game_state, [0, 1, 1])).to include([0, 0])
      end
      it "can move legally" do
        expect(board_king.grab_available_moves(board_for_king.game_state, [0, 1, 1])).to include([2, 1])
      end
      it "can move legally" do
        expect(board_king.grab_available_moves(board_for_king.game_state, [0, 1, 1])).to include([2, 2])
      end
      it "can't move illegally" do
        expect(board_king.grab_available_moves(board_for_king.game_state, [0, 1, 1])).to_not include([2, 0])
      end
      it "can't move illegally" do
        expect(board_king.grab_available_moves(board_for_king.game_state, [0, 1, 1])).to_not include([3, 1])
      end
      it "can take legally" do
        expect(board_king.grab_available_captures(board_for_king.game_state, [0, 1, 1])).to include([0, 1])
      end
      it "can't take illegally" do
        expect(board_king.grab_available_captures(board_for_king.game_state, [0, 1, 1])).to_not include([3, 0])
      end
    end
  end
end
