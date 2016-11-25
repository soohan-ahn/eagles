class SeasonsController < ApplicationController
	def show
		render template: "seasons/#{params[:page]}"
	end
end
