# frozen_string_literal: true

require_relative("../lib/game_board")

describe OdinChess::GameBoard do
  describe "#parse" do
    subject(:board_parse) { described_class.new(0, 0) }

    context "when given \"0-0\"" do
      it "calls parse_castle" do
        expect(board_parse).to receive(:parse_castle)
        board_parse.parse("0-0")
      end
      it "returns [\"Castle\"]" do
        parse = board_parse.parse("0-0")
        expect(parse).to eq(["Castle"])
      end
    end

    context "when given \"0-0-0\"" do
      it "calls parse_castle" do
        expect(board_parse).to receive(:parse_castle)
        board_parse.parse("0-0-0")
      end
      it "returns [\"Long castle\"]" do
        parse = board_parse.parse("0-0-0")
        expect(parse).to eq(["Long castle"])
      end
    end

    context "when given Ra8a7" do
      it "calls parse_piece_move" do
        expect(board_parse).to receive(:parse_piece_move)
        board_parse.parse("Ra8a7")
      end
      it "returns [R, 0, 7, 0, 6]" do
        parse = board_parse.parse("Ra8a7")
        expect(parse).to eq([OdinChess::Rook, 7, 0, 6, 0, 0])
      end
    end

    context "when given e6e7" do
      it "calls parse_pawn_move" do
        expect(board_parse).to receive(:parse_pawn_move)
        board_parse.parse("e6e7")
      end
      it "returns [P, 4, 5, 4, 6]" do
        parse = board_parse.parse("e6e7")
        expect(parse).to eq([OdinChess::Pawn, 5, 4, 6, 4, 0])
      end
    end

    context "when given Ba8xa7" do
      it "calls parse_piece_capture" do
        expect(board_parse).to receive(:parse_piece_capture)
        board_parse.parse("Ba8xa7")
      end
      it "returns [B, 0, 7, 0, 6]" do
        parse = board_parse.parse("Ba8xa7")
        expect(parse).to eq([OdinChess::Bishop, 7, 0, 6, 0, 1])
      end
    end

    context "when given e4xd5" do
      it "calls parse_pawn_capture" do
        expect(board_parse).to receive(:parse_pawn_capture)
        board_parse.parse("e4xd5")
      end
      it "returns [P, 4, 3, 3, 4]" do
        parse = board_parse.parse("e4xd5")
        expect(parse).to eq([OdinChess::Pawn, 3, 4, 4, 3, 1])
      end
    end

    context "when given invalid moves" do
      ["11111", "Ra88a7", "xxxxXx", "", "Rj4of", "j1xj2", "PE3E4", "00-00", "e4e5Px", "e4w5"].each do |input|
        it "returns non-valid move for #{input.inspect}" do
          parse = board_parse.parse(input)
          expect(parse.shift == "Invalid" || parse.any? { |char| !char.between?(0, 7) }).to be_truthy
        end
      end
    end
  end

  describe "#check_technically_valid" do
    subject(:board_check) { described_class.new(0, 0) }

    context "when given valid moves" do
      [["Castle"], ["Long Castle"], ["R", 0, 7, 0, 6, 0], ["P", 4, 5, 4, 6, 0], ["B", 0, 7, 0, 6, 1], ["P", 4, 3, 3, 4, 1]].each do |input|
        it "returns true for #{input.inspect}" do
          check = board_check.check_technically_valid(input)
          expect(check).to be_truthy
        end
      end
    end
    context "when given invalid moves" do
      ["11111", "Ra88a7", "xxxxXx", "", "Rj4of", "j1xj2", "PE3E4", "00-00", "e4e5Px", "e4w5"].each do |input|
        it "returns false for #{input.inspect}" do
          check = board_check.check_technically_valid(board_check.parse(input))
          expect(check).to be_falsy
        end
      end
    end
  end

  describe "#piece_at_cell" do
    subject(:board_piece_logic) { described_class.new(0, 0) }
    context "when game_state is unchanged" do
      # before do
      #   allow_any_instance_of(Kernel).to receive(:puts)
      # end
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
    subject(:board_target) { described_class.new(player1, player2) }
    context "when game_state is unchanged" do
      before do
        allow_any_instance_of(Kernel).to receive(:puts)
      end
      context "when moving to empty cell" do
        before do
          allow(player1).to receive(:active).and_return(true)
          allow(player2).to receive(:active).and_return(false)
        end
        [[[2, 0], 0], [[5, 2], 0], [[4, 4], 0]].each do |input|
          it "returns true for #{input.inspect}" do
            check = board_target.target_cell_ok(input[0], input[1])
            expect(check).to be_truthy
          end
        end
      end
      context "when capturing to empty cell" do
        before do
          allow(player1).to receive(:active).and_return(true)
          allow(player2).to receive(:active).and_return(false)
        end
        [[[2, 0], 1], [[5, 2], 1], [[4, 4], 1]].each do |input|
          it "returns false for #{input.inspect}" do
            check = board_target.target_cell_ok(input[0], input[1])
            expect(check).to be_falsy
          end
        end
      end
      context "when white is capturing to tile with black" do
        before do
          allow(player1).to receive(:active).and_return(true)
          allow(player2).to receive(:active).and_return(false)
        end
        [[[7, 4], 1], [[6, 2], 1], [[7, 4], 1]].each do |input|
          it "returns true for #{input.inspect}" do
            check = board_target.target_cell_ok(input[0], input[1])
            expect(check).to be_truthy
          end
        end
      end
      context "when white is capturing to tile with white" do
        before do
          allow(player1).to receive(:active).and_return(true)
          allow(player2).to receive(:active).and_return(false)
        end
        [[[1, 4], 1], [[1, 2], 1], [[0, 4], 1]].each do |input|
          it "returns false for #{input.inspect}" do
            check = board_target.target_cell_ok(input[0], input[1])
            expect(check).to be_falsy
          end
        end
      end
      context "when black is capturing to tile with black" do
        before do
          allow(player1).to receive(:active).and_return(false)
          allow(player2).to receive(:active).and_return(true)
        end
        [[[7, 4], 1], [[6, 2], 1], [[7, 4], 1]].each do |input|
          it "returns false for #{input.inspect}" do
            check = board_target.target_cell_ok(input[0], input[1])
            expect(check).to be_falsy
          end
        end
      end
      context "when black is capturing to tile with white" do
        before do
          allow(player1).to receive(:active).and_return(false)
          allow(player2).to receive(:active).and_return(true)
        end
        [[[1, 4], 1], [[1, 2], 1], [[0, 4], 1]].each do |input|
          it "returns true for #{input.inspect}" do
            check = board_target.target_cell_ok(input[0], input[1])
            expect(check).to be_truthy
          end
        end
      end
    end
  end
end
