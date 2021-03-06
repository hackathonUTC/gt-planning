class ParticipantsController < ApplicationController
	def index
	end

	def new
		@participant = Participant.new
		@event = Event.new
		@event_en_cours = Event.last
	end
	def create
		@event = Event.new(event_params)
		if ((event_params[:participants_attributes].count) != (Event.last.Nombre_de_Participants))
			@event.errors.add(:participant, "Pas le bon nombre de participans !")
			render 'new'
		else
			event_params[:participants_attributes].each do |part|
				params_boxes = event_params.except(:_destroy)
				@nparti = Participant.new(part.second.except(:_destroy))
				@nparti.event_id = Event.last.id
				@nparti.save
			end
		redirect_to new_disponibilite_path
		end
	end
	def edit
		@participant = Participant.find(params[:id])
	end
	def update
		@participant = Participant.find(params[:id])
			if @participant.update(participant_params)
  		  			redirect_to participants_path
  		  	else
  		  			render 'edit'
  		  	end
	end



	 private 
  		def event_params
  			params.require(:event).permit!
  			#(:Nom, :Nombre_de_Participants, :Nombre_de_Creneaux, :Nombre_de_Creneaux_par_Participant, :event_id, creneaus_attributes: [:id, :date_fin, :date_debut, :Nombre_de_Participants_Necessaires, :_destroy], participants_attributes: [:id, :nom, :event_id, :_destroy])
  		end
  		def participant_params
  			params.require(:participant).permit(:nom)
  		end
end
