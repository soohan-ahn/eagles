require 'rails_helper'

RSpec.describe GameBatterRecord, type: :model do
  it "summurize from result_code" do
    player1 = Player.create!(
      id: 1,
      name: "ASH",
    )
    player2 = Player.create!(
      id: 2,
      name: "ASHA",
    )
    # 1st batter
    #params[:result_code][inning.to_s][batting_order.to_s]
    #game_id: params[:batting_game_id][batting_order.to_s]
    params = {}
    params[:batting_player_name] = {}
    params[:batting_game_id] = {}
    params[:result_code] = {}
    (1..9).each { |inning| params[:result_code][inning.to_s] = {} }
    params[:batting_rbi] = {}
    params[:batting_run] = {}
    params[:batting_steal] = {}
    params[:batting_steal_caught] = {}

    params[:batting_player_name]["1"] = "ASH"
    params[:batting_game_id]["1"] = "1"
    params[:batting_rbi]["1"] = "0"
    params[:batting_run]["1"] = "0"
    params[:batting_steal]["1"] = "0"
    params[:batting_steal_caught]["1"] = "0"
    params[:result_code]["1"]["1"] = "555"
    params[:result_code]["3"]["1"] = "751"
    params[:result_code]["5"]["1"] = "41 730"
    params[:result_code]["6"]["1"] = "21"

    # 2nd batter
    params[:batting_player_name]["2"] = "ASHA"
    params[:batting_game_id]["2"] = "1"
    params[:batting_rbi]["2"] = "0"
    params[:batting_run]["2"] = "0"
    params[:batting_steal]["2"] = "0"
    params[:batting_steal_caught]["2"] = "0"
    params[:result_code]["1"]["2"] = "782"
    params[:result_code]["3"]["2"] = "784"
    params[:result_code]["5"]["2"] = "783 10"

    @params_for_first_batter = GameBatterRecord.params_for_save(params, 1)
    expect(@params_for_first_batter[:plate_appearence]).to eq(5)
    expect(@params_for_first_batter[:at_bat]).to eq(3)
    expect(@params_for_first_batter[:total_hits]).to eq(1)
    expect(@params_for_first_batter[:one_base_hit]).to eq(1)
    expect(@params_for_first_batter[:two_base_hit]).to eq(0)
    expect(@params_for_first_batter[:three_base_hit]).to eq(0)
    expect(@params_for_first_batter[:home_run]).to eq(0)
    expect(@params_for_first_batter[:strike_out]).to eq(0)
    expect(@params_for_first_batter[:base_on_ball]).to eq(1)
    expect(@params_for_first_batter[:hit_by_pitched_ball]).to eq(1)
    expect(@params_for_first_batter[:on_base_by_error]).to eq(1)

    @params_for_second_batter = GameBatterRecord.params_for_save(params, 2)
    expect(@params_for_second_batter[:plate_appearence]).to eq(4)
    expect(@params_for_second_batter[:at_bat]).to eq(4)
    expect(@params_for_second_batter[:total_hits]).to eq(3)
    expect(@params_for_second_batter[:one_base_hit]).to eq(0)
    expect(@params_for_second_batter[:two_base_hit]).to eq(1)
    expect(@params_for_second_batter[:three_base_hit]).to eq(1)
    expect(@params_for_second_batter[:home_run]).to eq(1)
    expect(@params_for_second_batter[:strike_out]).to eq(1)
    expect(@params_for_second_batter[:base_on_ball]).to eq(0)
    expect(@params_for_second_batter[:hit_by_pitched_ball]).to eq(0)
    expect(@params_for_second_batter[:on_base_by_error]).to eq(0)
  end
end
