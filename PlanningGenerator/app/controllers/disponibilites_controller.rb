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
		disponibilite.update(id: disponibilite.id)
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

		tableau = Array.new
		@disposCreneau = Disponibilite.where(creneau: creneau)
		if creneau_rempli(creneau)
			return tableau
		else

			@disposCreneau.where(active: 1).each do |p|
				@dispos_prises_du_Participant = Disponibilite.where({participant: p.participant, active: 0})
				if @dispos_prises_du_Participant.count < Event.last.Nombre_de_Creneaux_par_Participant 
					tableau.push(p.participant)
				end
			end

			return tableau
		end

	end
	

	def Meilleur_Choix (listeParticipants)
		i = 0
		tableau_restant=Array.new
		table = Array.new

		listeParticipants.each do |p| 
			@dispos_actives = Disponibilite.where(participant: p, active: 1)
			if (@dispos_actives)
				tableau_restant[i]=[@dispos_actives.count,p]
				i += 1
			end
		end
		tab_min = Array.new
		if tableau_restant
			min = tableau_restant.min.first
			tableau_restant.each do |t|
				if t.first == min
					tab_min << t.second
				end
			end #Stocke lesdispo des éléments de la liste avc le moins de disponibilité actives (Sauf ceux en ayant 0)
		else
			return nil
		end
		
		sortie = nil
		base = 9999
		tab_min.each do |t|
			@dispos_inactives = Disponibilite.where({participant: t, active: 0})
			if (@dispos_inactives) && (@dispos_inactives.count) < base
				base = @dispos_inactives.count
				sortie = t #renvoie une personne
			end
		end

		return sortie
	end 

	def main

		if Event_Valide()
			Placement_Tout_Participant()
			while not(chaque_creneau_rempli())

				creneau_min = find_min_creneau()
				potentiels_participants = Personnes_Disponibles(creneau_min)
				if (potentiels_participants.count == 0)
					return "Planning impossible, changez certains paramètres"
				end
				choix = Meilleur_Choix(potentiels_participants)

				dispo_a_changer = Disponibilite.where(participant: choix, creneau: creneau_min, active: 1).first
				dispo_a_changer.active = 0
				dispo_a_changer.update(id: dispo_a_changer.id)

			end
		else
			return "Planning impossible, changez certains paramètres"
		end

		return nil

	end


	def index
			@caca = main()
	end		

	def show
		@disponibilie = Disponibilite.find(:id)
	end

	def new
		@disponibilite = Disponibilite.new
		@participants = Participant.all
		@creneaux = Creneau.all
		@event_en_cours = Event.last

	end
	def create
		nparams = params.except(:utf8, :authenticity_token, :commit, :controller, :action)
		groupeDispos = Array.new
		i = 0
		nparams.each do |groupe|
			groupe.second.each do |s|
				groupeDispos[i] = Disponibilite.new(:participant_id => groupe.first, :creneau_id => s, :active => 1)
				i += 1
			end
		end
		Disponibilite.import groupeDispos
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
		DatabaseCleaner.clean
		redirect_to new_event_path
	end

	def rm_dispos
		@disponibilite = Disponibilite.new
		@participants = Participant.all
		@creneaux = Creneau.all
		Disponibilite.destroy_all

		redirect_to new_disponibilite_path
	end

end

