class DisponibilitesController < ApplicationController
	def index
	end

	def show
		@disponibilie = Disponibilite.find(:id)
	end

	def new
		@disponibilite = Disponibilite.new
	end
	def create
		nparams = params.except(:utf8, :authenticity_token, :commit, :controller, :action)
		nparams.each do |groupe|
			groupe.second.each do |s|
				@dispo = Disponibilite.new
				@dispo.participant_id = groupe.first
				@dispo.creneau_id = s
				@dispo.active = 1
				@dispo.save
			end
		end
		redirect_to 'disponibilites_path'
	end

	def disponibilite_params
  			params.require(:disponibilite).permit!
		end
end
