class TotalPitcherRecord < ActiveRecord::Base
  belongs_to :player

	def self.summarize
    true
  end
end
