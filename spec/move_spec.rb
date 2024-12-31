#

require_relative("../lib/move")

describe OdinChess::Move do
  describe "#parse" do
    context "when given \"0-0\"" do
      it "calls parse_castle" do
        expect(described_class).to receive(:parse_castle)
        described_class.from_string("0-0")
      end
      it "returns move of type castle" do
        move = described_class.from_string("0-0")
        expect(move.type).to eq("Castle")
      end
    end

    context "when given \"0-0-0\"" do
      it "calls parse_castle" do
        expect(described_class).to receive(:parse_castle)
        described_class.from_string("0-0-0")
      end
      it "returns move of type long castle" do
        move = described_class.from_string("0-0-0")
        expect(move.type).to eq("Long Castle")
      end
    end

    context "when given Ra8a7" do
      it "calls from_piece_move" do
        expect(described_class).to receive(:from_piece_move)
        described_class.from_string("Ra8a7")
      end
      it "returns Rook moving from a8 to a7" do
        move = described_class.from_string("Ra8a7")
        expect(move.p_class).to eq(OdinChess::Rook)
        expect(move.row).to eq(7)
        expect(move.col).to eq(0)
        expect(move.target_row).to eq(6)
        expect(move.target_col).to eq(0)
        expect(move.is_capture).to be_falsy
      end
    end

    context "when given e6e7" do
      it "calls from_pawn_move" do
        expect(described_class).to receive(:from_pawn_move)
        described_class.from_string("e6e7")
      end
      it "returns Pawn moving from e6 to e7" do
        move = described_class.from_string("e6e7")
        expect(move.p_class).to eq(OdinChess::Pawn)
        expect(move.row).to eq(5)
        expect(move.col).to eq(4)
        expect(move.target_row).to eq(6)
        expect(move.target_col).to eq(4)
        expect(move.is_capture).to be_falsy
      end
    end

    context "when given Ba8xa7" do
      it "calls from_piece_capture" do
        expect(described_class).to receive(:from_piece_capture)
        described_class.from_string("Ba8xa7")
      end
      it "returns Bishop capturing from a8 to a7" do
        move = described_class.from_string("Ba8xa7")
        expect(move.p_class).to eq(OdinChess::Bishop)
        expect(move.row).to eq(7)
        expect(move.col).to eq(0)
        expect(move.target_row).to eq(6)
        expect(move.target_col).to eq(0)
        expect(move.is_capture).to be_truthy
      end
    end

    context "when given e4xd5" do
      it "calls from_pawn_capture" do
        expect(described_class).to receive(:from_pawn_capture)
        described_class.from_string("e4xd5")
      end
      it "returns Pawn capturing from e4 to d5" do
        move = described_class.from_string("e4xd5")
        expect(move.p_class).to eq(OdinChess::Pawn)
        expect(move.row).to eq(3)
        expect(move.col).to eq(4)
        expect(move.target_row).to eq(4)
        expect(move.target_col).to eq(3)
        expect(move.is_capture).to be_truthy
      end
    end

    context "when given invalid moves" do
      ["11111", "Ra88a7", "xxxxXx", "", "Rj4of", "j1xj2", "PE3E4", "00-00", "e4e5Px", "e4w5"].each do |input|
        it "returns non-valid move for #{input.inspect}" do
          move = described_class.from_string(input)
          expect(move.type == "Invalid" || !move.technically_valid?).to be_truthy
        end
      end
    end

    describe "#technically_valid?" do
      context "when given valid moves" do
        %w[Ra8a7 e6e7 Ba8xa7 e4xd5].each do |input|
          it "returns true for move produced from #{input.inspect}" do
            move = described_class.from_string(input)
            expect(move.technically_valid?).to be_truthy
          end
        end
      end
      context "when given invalid moves" do
        ["11111", "Ra88a7", "xxxxXx", "", "Rj4of", "j1xj2", "PE3E4", "00-00", "e4e5Px", "e4w5"].each do |input|
          it "returns false for move produced from #{input.inspect}" do
            move = described_class.from_string(input)
            expect(move.technically_valid?).to be_falsy
          end
        end
      end
    end
  end
end
