require "rails_helper"

RSpec.describe TotalPitcherRecord, type: :model do
  it "Make total_pitcher_records properly" do
    player1 = Player.create!(
      id: 1,
      name: "ASH",
    )
    player2 = Player.create!(
      id: 2,
      name: "ASHA",
    )
    SeasonPitcherRecord.create!(
      player_id: 1,
      year: 2015,
      win: 1,
      inning_pitched: 1.33,
      hit: 1,
      run: 3,
      earned_run: 2,
      strike_out: 3,
      walk: 1,
      hit_by_pitch: 1,
    )

    SeasonPitcherRecord.create!(
      player_id: 1,
      year: 2016,
      lose: 1,
      inning_pitched: 1.66,
      hit: 0,
      run: 1,
      earned_run: 1,
      strike_out: 0,
      walk: 3,
      hit_by_pitch: 1,
    )

    SeasonPitcherRecord.create!(
      player_id: 2,
      year: 2015,
      inning_pitched: 2.33,
      hit: 1,
      homerun: 1,
      run: 3,
      earned_run: 3,
      strike_out: 3,
      walk: 2,
      hit_by_pitch: 0,
    )

    SeasonPitcherRecord.create!(
      player_id: 2,
      year: 2016,
      inning_pitched: 0.00,
      hit: 1,
      homerun: 1,
      run: 1,
      earned_run: 1,
      strike_out: 0,
      walk: 0,
      hit_by_pitch: 0,
    )

    TotalPitcherRecord.summarize
    total_pitcher_record = player1.total_pitcher_records.first

    expect(total_pitcher_record.inning_pitched).to eq(3.00)
    expect(total_pitcher_record.win).to eq(1)
    expect(total_pitcher_record.lose).to eq(1)
    expect(total_pitcher_record.walk).to eq(4)
    expect(total_pitcher_record.hit_by_pitch).to eq(2)
    expect(total_pitcher_record.era).to eq(7.00)
    

    total_pitcher_record2 = player2.total_pitcher_records.first
    expect(total_pitcher_record2.inning_pitched).to eq(2.33)
    expect(total_pitcher_record2.win).to eq(0)
    expect(total_pitcher_record2.lose).to eq(0)
    expect(total_pitcher_record2.walk).to eq(2)
    expect(total_pitcher_record2.era).to eq(12.02)
  end
end
