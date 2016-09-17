require "rails_helper"

RSpec.describe Player, :type => :model do
  it "sums the pitched inning properly" do
    player = Player.create!(
      id: 1,
      name: "ASH",
    )

    first_game_record = GamePitcherRecord.create!(
      player_id: player.id,
      game_id: 1,
      pitched_order: 1,
      innings_pitched: 1.66,
    )

    second_game_record = GamePitcherRecord.create!(
      player_id: player.id,
      game_id: 2,
      pitched_order: 1,
      innings_pitched: 3.33,
    )

    expect(player.inning_pitched).to eq(5)
  end
end