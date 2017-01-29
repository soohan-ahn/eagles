require "rails_helper"

RSpec.describe SeasonBatterRecord, :type => :model do
	it "Create SeasonBatterRecord properly" do
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

    GameBatterRecord.create!(
			player_id: 1,
			game_id: 1,
      rbi: 3,
      run: 2,
      steal: 1,
      plate_appearence: 3,
      at_bat: 3,
      total_hits: 2,
      one_base_hit: 1,
      two_base_hit: 1,
      three_base_hit: 0,
      home_run: 0,
      strike_out: 1,
      base_on_ball: 0,
      hit_by_pitched_ball: 0,
    )

    GameBatterRecord.create!(
      player_id: 2,
      game_id: 1,
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

    AtBatBatterRecord.create!(
      player_id: 1,
      game_id: 1,
      batting_order: 1,
      position: 2,
      inning: 1,
      at_plate_order: 1,
      result_code: 10,
    )

    AtBatBatterRecord.create!(
      player_id: 1,
      game_id: 1,
      batting_order: 1,
      position: 2,
      inning: 3,
      at_plate_order: 2,
      result_code: 751,
    )

    AtBatBatterRecord.create!(
      player_id: 1,
      game_id: 1,
      batting_order: 1,
      position: 2,
      inning: 5,
      at_plate_order: 3,
      result_code: 782,
    )
    AtBatBatterRecord.create!(
      player_id: 2,
      game_id: 1,
      batting_order: 2,
      position: 3,
      inning: 1,
      at_plate_order: 1,
      result_code: 10,
    )

    AtBatBatterRecord.create!(
      player_id: 2,
      game_id: 1,
      batting_order: 2,
      position: 3,
      inning: 3,
      at_plate_order: 2,
      result_code: 555,
    )

    AtBatBatterRecord.create!(
      player_id: 2,
      game_id: 1,
      batting_order: 2,
      position: 3,
      inning: 5,
      at_plate_order: 3,
      result_code: 41,
    )

    # Game2
    GameBatterRecord.create!(
      player_id: 1,
      game_id: 2,
      rbi: 1,
      run: 2,
      steal: 3,
      plate_appearence: 3,
      at_bat: 1,
      total_hits: 0,
      one_base_hit: 0,
      two_base_hit: 0,
      three_base_hit: 0,
      home_run: 0,
      strike_out: 1,
      base_on_ball: 2,
      hit_by_pitched_ball: 0,
    )

    GameBatterRecord.create!(
      player_id: 2,
      game_id: 2,
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

    AtBatBatterRecord.create!(
      player_id: 1,
      game_id: 2,
      batting_order: 1,
      position: 2,
      inning: 1,
      at_plate_order: 1,
      result_code: 41,
    )

    at_bat_batter_records1 = AtBatBatterRecord.create!(
      player_id: 1,
      game_id: 2,
      batting_order: 1,
      position: 2,
      inning: 3,
      at_plate_order: 2,
      result_code: 41,
    )

    at_bat_batter_records1 = AtBatBatterRecord.create!(
      player_id: 1,
      game_id: 2,
      batting_order: 1,
      position: 2,
      inning: 5,
      at_plate_order: 3,
      result_code: 10,
    )
    at_bat_batter_records1 = AtBatBatterRecord.create!(
      player_id: 2,
      game_id: 2,
      batting_order: 2,
      position: 3,
      inning: 1,
      at_plate_order: 1,
      result_code: 10,
    )

    at_bat_batter_records1 = AtBatBatterRecord.create!(
      player_id: 2,
      game_id: 2,
      batting_order: 2,
      position: 3,
      inning: 3,
      at_plate_order: 2,
      result_code: 41,
    )

    at_bat_batter_records1 = AtBatBatterRecord.create!(
      player_id: 2,
      game_id: 2,
      batting_order: 2,
      position: 3,
      inning: 5,
      at_plate_order: 3,
      result_code: 774,
    )

    SeasonBatterRecord.refresh_season_records(2016)
    season_batter_record = player1.season_batter_records.find_by(year: 2016)

    expect(season_batter_record.rbi).to eq(4)
    expect(season_batter_record.run).to eq(4)
    expect(season_batter_record.steal).to eq(4)
    expect(season_batter_record.batting_average).to eq(0.500)
    expect(season_batter_record.on_base_percentage).to eq(0.667)
    expect(season_batter_record.slugging_percentage).to eq(0.750)

    season_batter_record2 = player2.season_batter_records.find_by(year: 2016)
    expect(season_batter_record2.rbi).to eq(5)
    expect(season_batter_record2.run).to eq(3)
    expect(season_batter_record2.steal).to eq(3)
    expect(season_batter_record2.batting_average).to eq(0.250)
    expect(season_batter_record2.on_base_percentage).to eq(0.500)
    expect(season_batter_record2.slugging_percentage).to eq(1.000)
	end
end
