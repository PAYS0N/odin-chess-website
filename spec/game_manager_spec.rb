# frozen_string_literal: true

require_relative("../lib/game_manager")

describe OdinChess::GameManager do
  describe "#player_setup" do
    subject(:game_setup) { described_class.new }
    let(:player1) { instance_double("player", name: nil) }
    let(:player2) { instance_double("player", name: nil) }

    before do
      game_setup.instance_variable_set(:@player1, player1)
      game_setup.instance_variable_set(:@player2, player2)
      allow(OdinChess::UI).to receive(:grab_name).and_return("Jack", "Jill")
      allow(player1).to receive(:name=)
      allow(player2).to receive(:name=)
    end

    it "returns player1 if name given is Jack" do
      allow(OdinChess::UI).to receive(:grab_first).and_return("Jack")
      first_player = game_setup.player_setup
      expect(first_player.name).to eq(player1.name)
    end

    it "returns player2 if name given is Jill" do
      allow(OdinChess::UI).to receive(:grab_first).and_return("Jill")
      first_player = game_setup.player_setup
      expect(first_player.name).to eq(player2.name)
    end
  end
end
