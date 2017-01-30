require "rails_helper"

RSpec.describe SeasonPitcherRecord, :type => :model do
  it "sums the pitched inning properly" do
    expect(SeasonPitcherRecord.total_inning_pitched([1.66, 3.33])).to eq(5)
  end

  it "sums the pitched inning properly 0.66+0.66" do
    expect(SeasonPitcherRecord.total_inning_pitched([1.66, 3.66])).to eq(5.33)
  end

	it "Create SeasonPitcherRecord properly" do
		player1 = Player.create!(
      id: 1,
      name: "ASH",
    )
    player2 = Player.create!(
      id: 2,
      name: "ASHA",
    )
    game = Game.create!(
    	id: 1,
    	home_team: "Black",
      away_team: "White",
      game_start_time: DateTime.new(2016,9,15,13,00,00,'+9')
    )
    game = Game.create!(
      id: 2,
      home_team: "White",
      away_team: "Black",
      game_start_time: DateTime.new(2016,9,16,13,00,00,'+9')
    )

    GamePitcherRecord.create!(
      player_id: 1,
      game_id: 1,
      pitched_order: 1,
      win: 1,
      innings_pitched: 1.33,
      plate_appearance: 8,
      at_bat: 6,
      hit: 1,
      run: 3,
      earned_run: 2,
      strike_out: 3,
      walk: 1,
      hit_by_pitch: 1,
      number_of_pitches: 40,
    )

    GamePitcherRecord.create!(
      player_id: 1,
      game_id: 2,
      pitched_order: 1,
      lose: 1,
      innings_pitched: 1.66,
      plate_appearance: 8,
      at_bat: 4,
      hit: 0,
      run: 1,
      earned_run: 1,
      strike_out: 0,
      walk: 3,
      hit_by_pitch: 1,
      number_of_pitches: 50,
    )

    GamePitcherRecord.create!(
      player_id: 2,
      game_id: 1,
      pitched_order: 2,
      innings_pitched: 2.33,
      plate_appearance: 10,
      at_bat: 8,
      hit: 1,
      homerun: 1,
      run: 3,
      earned_run: 3,
      strike_out: 3,
      walk: 2,
      hit_by_pitch: 0,
      number_of_pitches: 30,
    )

    GamePitcherRecord.create!(
      player_id: 2,
      game_id: 2,
      pitched_order: 2,
      innings_pitched: 0.00,
      plate_appearance: 1,
      at_bat: 1,
      hit: 1,
      homerun: 1,
      run: 1,
      earned_run: 1,
      strike_out: 0,
      walk: 0,
      hit_by_pitch: 0,
      number_of_pitches: 1,
    )


    SeasonPitcherRecord.refresh_season_records(2016)
    season_pitcher_record = player1.season_pitcher_records.find_by(year: 2016)

    expect(season_pitcher_record.inning_pitched).to eq(3.00)
    expect(season_pitcher_record.win).to eq(1)
    expect(season_pitcher_record.lose).to eq(1)
    expect(season_pitcher_record.walk).to eq(4)
    expect(season_pitcher_record.hit_by_pitch).to eq(2)
    expect(season_pitcher_record.era).to eq(7.00)
    

    season_pitcher_record2 = player2.season_pitcher_records.find_by(year: 2016)
    expect(season_pitcher_record2.inning_pitched).to eq(2.33)
    expect(season_pitcher_record2.win).to eq(0)
    expect(season_pitcher_record2.lose).to eq(0)
    expect(season_pitcher_record2.walk).to eq(2)
    expect(season_pitcher_record2.era).to eq(12.02)
	end
end