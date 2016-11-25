class SeasonsController < ApplicationController
	def show
		render template: "seasons/#{params[:year]}"
	end
end
