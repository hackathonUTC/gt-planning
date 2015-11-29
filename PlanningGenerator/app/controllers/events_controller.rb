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
		nombre = event_params[:creneaus_attributes].count
		@event = Event.new(event_params)
		@event.Nombre_de_Creneaux = nombre
  		if @event.save
		  				redirect_to @event
		  	else
		  			render 'new'
		  	end
	end




	 private 
  		def event_params
  			params.require(:event).permit(:Nom, :Nombre_de_Participants, :Nombre_de_Creneaux, :Nombre_de_Creneaux_par_Participant, :event_id, creneaus_attributes: [:id, :date_fin, :date_debut, :Nombre_de_Participants_Necessaires, :_destroy])
		end
end
