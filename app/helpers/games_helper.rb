module GamesHelper
  def inning_score(score_boxes, inning, top_bottom)
    inning_score_information = score_boxes.find_by(inning: inning, top_bottom: top_bottom)
    inning_score_information ? inning_score_information.score : "0"
  end

  def score_box_inning_id (i, j)
    if i == 1
      "#{j}\ttop\t"
    elsif i == 2
      "#{j}\tbottom\t"
    end
  end
end
