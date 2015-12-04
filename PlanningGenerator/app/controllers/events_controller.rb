class EventsController < ApplicationController
	def index
	end

	def show
		@event = Event.find(params[:id])
	end

	def new
		@event = Event.new
	end

	def create
		nlem = nil
		@event = Event.new(event_params)
		if (event_params[:creneaus_attributes] == nil)
			@event.errors.add(:event, ": Pas de Créneau(x) choisi(s)")
			render 'new'
		else
			event_params[:creneaus_attributes].each do |par|
				if (par.second[:date_debut] >= par.second[:date_fin])
					nlem = false
				end
			end
			if(nlem)
				@event.errors.add(:creneaus_attributes,  " : La date de début doit être inférieure à celle de fin")
				render 'new'
			else
				@event = Event.new(event_params)
				nombre = event_params[:creneaus_attributes].count
				@event.Nombre_de_Creneaux = nombre
		  		if @event.save
		  				
				  		redirect_to new_participant_path
				else
				  		render 'new'
				end
			end
		end
	end
	def edit
			@event = Event.find(params[:id])
	end
	def update
		@event = Event.find(params[:id])
			if @event.update(event_params)
					@disponibilite = Disponibilite.new
					@participants = Participant.all
					@creneaux = Creneau.all
					@event_en_cours = Event.last
  		  			redirect_to new_disponibilite_path
  		  	else
  		  			render 'edit'
  		  	end
	end




	 private 
  		def event_params
  			params.require(:event).permit(:Nom, :Nombre_de_Participants, :Nombre_de_Creneaux, :Nombre_de_Creneaux_par_Participant, :event_id, creneaus_attributes: [:id, :date_fin, :date_debut, :Nombre_de_Participants_Necessaires, :nom_creneau, :_destroy])
		end
end
