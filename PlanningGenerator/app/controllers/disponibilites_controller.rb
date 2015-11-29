class DisponibilitesController < ApplicationController

	def index

		def Event_Valide 

        	Creneau.all.each do |c|
	            if Disponibilite.where({creneau: c}).count < c.Nombre_de_Participants_Necessaires
	                return nil
	            end
        	end
    		return true
    	end

    	def Placement_un_participant(id)

			participant = Participant.find(id)
			creneaux_non_dispo = Array.new
			creneaux_dispo = Array.new

			Disponibilite.where({participant: participant}).each do |pDispos|
				if (pDispos.active == 0)
					creneaux_non_dispo.push(pDispos)
				else
					creneaux_dispo.push(pDispos)
				end
			end
			if ((creneaux_dispo.count == 1) && (creneaux_non_dispo.count < Event.last.Nombre_de_Creneaux_par_Participant))
				@cren = creneaux_dispo.first
				@cren.active = 0
				@cren.update(disponibilite_params)
			end
			return 0
		end

		@caca= Placement_un_participant(1)
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
		redirect_to disponibilites_path
	end

	def update
		@disponibilite = Disponibilite.find(params[:id])

		if @disponibilite.update(character_params)
			redirect_to @disponibilite
		else
			render 'edit'
		end
	end

	def disponibilite_params
  			params.require(:disponibilite).permit!
		end
end
