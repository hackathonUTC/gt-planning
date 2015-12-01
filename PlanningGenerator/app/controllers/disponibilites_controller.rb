class DisponibilitesController < ApplicationController


		def Event_Valide()
			max_creneau = Event.last.Nombre_de_Participants * Event.last.Nombre_de_Creneaux_par_Participant
			needCreneau = 0
        	bool = true
        	Creneau.all.each do |c|
        		needCreneau += c.Nombre_de_Participants_Necessaires
	            if Disponibilite.where({creneau: c}).count < c.Nombre_de_Participants_Necessaires
	                bool = nil
	            end
        	end
        	if needCreneau > max_creneau
        		bool = nil
        	end
    		return bool
    	end

    	#Je walide la fonction ci dessus la 


    	def creneau_rempli (creneau)
  			dispo_utilise = Disponibilite.where({creneau: creneau, active: 0})
			if dispo_utilise.count == creneau.Nombre_de_Participants_Necessaires
				return true
			else
				return nil
			end
		end

		def chaque_creneau_rempli
			Creneau.all.each do |c|
				if (not(creneau_rempli(c)))
					return nil
				end
			end
			return true
		end



		def Placer_dans_dispo (disponibilite)
			disponibilite.active = 0
			disponibilite.update(id: @disponibilite.id)
			return 0
		end
    	def Placement_un_participant(participant)

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
				@dispo_choisie = creneaux_dispo.first
				Placer_dans_dispo(@dispo_choisie)
			end
			return 0
		end

		def Placement_Tout_Participant
			Participant.all.each do |p|
				Placement_un_participant(p)
			end
			return 0
		end

		def find_min_1_creneau (creneau)
			if (not(creneau_rempli(creneau)))
				var = Disponibilite.where({active: 1, creneau: creneau})
				return var
			end
			return nil
		end


		def find_min_creneau
			nb_dispo = Array.new
			
			Creneau.all.each do |c|
			temp = find_min_1_creneau(c)
				if temp
					nb_dispo << [temp.count,c.id]	
				end
			end
			dispo_avec_count_mini = nb_dispo.min
			return Creneau.find(dispo_avec_count_mini.second)
		end

		def Personnes_Disponibles (creneau)

			id_c = creneau.id
			tableau = Array.new
			@disposCreneau = Disponibilite.where(creneau_id: id_c)
			@disposCreneau.each do |p|
			if (Disponibilite.where({participant_id: p.participant.id, active: 0}) !=0)
				if (Disponibilite.where({participant_id: p.participant.id, active: 0}).count < Event.last.Nombre_de_Creneaux_par_Participant)
					tableau.push(p.participant)
				end
			end
		end
			return tableau
		end

		

		def Meilleur_Choix (liste)
			i = 0
			tableau_restant=Array.new
			table = Array.new

			liste.each do |p|
				if (Disponibilite.where({participant: p, active: 1}).count != 0)
					tableau_restant[i]=[Disponibilite.where(participant: p, active: 1).count,p]
					i += 1
				end
			end
			tab_min = Array.new
			min = tableau_restant.min.first
			tableau_restant.each do |t|
				if t.first == min
					tab_min << t.second
				end
			end #Stocke lesdispo des éléments de la liste avc le moins de disponibilité actives (Sauf ceux en ayant 0)

			
			sortie = nil
			base = 9999
			tab_min.each do |t|
				#byebug
				if (Disponibilite.where({participant: t, active: 0}).count) < base && (Disponibilite.where({participant: t, active: 0}).count !=0)
					base = Disponibilite.where({participant: t, active: 0}).count
					sortie = t #renvoie une personne
				end
			end

			return sortie
		end 

		def main

			if Event_Valide()
				Placement_Tout_Participant()
				while not(chaque_creneau_rempli())
					a = find_min_creneau()
					b = Personnes_Disponibles(a)
					xx = Meilleur_Choix (b)
					#byebug

					yyy = Disponibilite.where({participant: xx, creneau: find_min_creneau(), active: 1})
					yyy.active = 0
					if yyy.count !=0
					
					#byebug

					
					yyy.update(id: yyy.id)
					yyy.save
				end

				end

			end
		end




			def index
=begin
				
				b = Placement_Tout_Participant()
				@Creneau = Creneau.all.find(16)
				personnesD = Personnes_Disponibles(@Creneau)
				plur = find_min_creneau()
				plural = Personnes_Disponibles(plur)
				jur = Meilleur_Choix(plural)
				#byebug
				main()
=end
			@ta_mere = Event_Valide()
			if @ta_mere
				@ta_mere = 1
			else
				@ta_mere = 0
			end
			end		

		#@rendu = Disponibilite.all.where({active: 0}).order(:date_debut)



	

		





	def show
		@disponibilie = Disponibilite.find(:id)
	end

	def new
		@disponibilite = Disponibilite.new
		@participants = Participant.all
		@creneaux = Creneau.all

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


	def fin
		Participant.destroy_all
		Event.destroy_all
		Disponibilite.destroy_all
		Creneau.destroy_all

		redirect_to 'home'
	end

end

