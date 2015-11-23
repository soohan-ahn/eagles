module GameDetailRecordsHelper
  def index_of_game_pitcher_records
    [
      "pitched_order",
      "player_id",
      "game_id",
      "result",
      "innings_pitched",
      "plate_appearance",
      "at_bat",
      "hit",
      "homerun",
      "sacrifice_bunt",
      "sacrifice_fly",
      "run",
      "earned_run",
      "strike_out",
      "walk",
      "intentional_walk",
      "hit_by_pitch",
      "wild_pitch",
      "balk",
      "number_of_pitches",
    ]
  end

  def index_of_game_pitcher_records_edit
    [
      "pitched_order",
      "player_id",
      "game_id",
      "win",
      "lose",
      "save_point",
      "hold",
      "innings_pitched",
      "plate_appearance",
      "at_bat",
      "hit",
      "homerun",
      "sacrifice_bunt",
      "sacrifice_fly",
      "run",
      "earned_run",
      "strike_out",
      "walk",
      "intentional_walk",
      "hit_by_pitch",
      "wild_pitch",
      "balk",
      "number_of_pitches",
    ]
  end

  def pitcher_result_code(pitcher)
    return "W" if pitcher.win
    return "L" if pitcher.lose
    return "SV" if pitcher.save_point
    return "H" if pitcher.hold
    ""
  end
end
