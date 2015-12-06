class CreneausController < ApplicationController

	def index

	end

	def edit
		@creneau = Creneau.find(params[:id])
		@event = Event.last
	end
	def update
		@creneau = Creneau.find(params[:id])
			if @creneau.update(creneau_params)
  		  			redirect_to creneaus_path
  		  	else
  		  			render 'edit'
  		  	end
	end
	def creneau_params
  			params.require(:creneau).permit(:date_debut, :date_fin, :Nombre_de_Participants_Necessaires)
  		end
end
