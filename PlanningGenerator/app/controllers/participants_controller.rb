class ParticipantsController < ApplicationController
	def index
	end

	def show
		@participant = Participant.find(params[:id])
		@event = Event.find(@participant.event_id)
	end
	def new
		@participant = Participant.new
		@event = Event.new
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




	 private 
  		def event_params
  			params.require(:event).permit!
  			#(:Nom, :Nombre_de_Participants, :Nombre_de_Creneaux, :Nombre_de_Creneaux_par_Participant, :event_id, creneaus_attributes: [:id, :date_fin, :date_debut, :Nombre_de_Participants_Necessaires, :_destroy], participants_attributes: [:id, :nom, :event_id, :_destroy])
  		end
end
