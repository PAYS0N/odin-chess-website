# frozen_string_literal: true

require_relative("../lib/game_board")

describe OdinChess::GameBoard do
  describe "#parse" do
    subject(:board_parse) { described_class.new(0, 0, 0) }

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
        expect(parse).to eq(["R", 0, 7, 0, 6, 0])
      end
    end

    context "when given e6e7" do
      it "calls parse_pawn_move" do
        expect(board_parse).to receive(:parse_pawn_move)
        board_parse.parse("e6e7")
      end
      it "returns [P, 4, 5, 4, 6]" do
        parse = board_parse.parse("e6e7")
        expect(parse).to eq(["P", 4, 5, 4, 6, 0])
      end
    end

    context "when given Ba8xa7" do
      it "calls parse_piece_capture" do
        expect(board_parse).to receive(:parse_piece_capture)
        board_parse.parse("Ba8xa7")
      end
      it "returns [B, 0, 7, 0, 6]" do
        parse = board_parse.parse("Ba8xa7")
        expect(parse).to eq(["B", 0, 7, 0, 6, 1])
      end
    end

    context "when given e4xd5" do
      it "calls parse_pawn_capture" do
        expect(board_parse).to receive(:parse_pawn_capture)
        board_parse.parse("e4xd5")
      end
      it "returns [P, 4, 3, 3, 4]" do
        parse = board_parse.parse("e4xd5")
        expect(parse).to eq(["P", 4, 3, 3, 4, 1])
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
    subject(:board_check) { described_class.new(0, 0, 0) }

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
end
