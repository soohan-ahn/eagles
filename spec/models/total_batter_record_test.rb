require "rails_helper"

RSpec.describe TotalBatterRecord, type: :model do
  it "properly make total_batter_record" do
    player1 = Player.create!(
      id: 1,
      name: "ASH",
    )
    player2 = Player.create!(
      id: 2,
      name: "ASHA",
    )
    SeasonBatterRecord.create!(
      player_id: 2,
      year: 2015,
      played_game: 10,
      rbi: 5,
      run: 3,
      steal: 1,
      plate_appearence: 3,
      at_bat: 2,
      total_hits: 1,
      one_base_hit: 0,
      two_base_hit: 0,
      three_base_hit: 0,
      home_run: 1,
      strike_out: 1,
      base_on_ball: 1,
      hit_by_pitched_ball: 0,
    )
    SeasonBatterRecord.create!(
      player_id: 2,
      year: 2016,
      played_game: 20,
      rbi: 0,
      run: 0,
      steal: 2,
      plate_appearence: 3,
      at_bat: 2,
      total_hits: 0,
      one_base_hit: 0,
      two_base_hit: 0,
      three_base_hit: 0,
      home_run: 0,
      strike_out: 1,
      base_on_ball: 1,
      hit_by_pitched_ball: 0,
    )

    TotalBatterRecord.summarize

    total_batter_record2 = player2.total_batter_records.first
    expect(total_batter_record2.played_game).to eq(30)
    expect(total_batter_record2.rbi).to eq(5)
    expect(total_batter_record2.run).to eq(3)
    expect(total_batter_record2.steal).to eq(3)
    expect(total_batter_record2.batting_average).to eq(0.250)
    expect(total_batter_record2.on_base_percentage).to eq(0.500)
    expect(total_batter_record2.slugging_percentage).to eq(1.000)
  end
end
