def Event_Valide 

        Creneau.each do |c|
            if Disponibilite.c.count < c.Nombre_de_Participants_Necessaires
                return nil
            end
        end
    	return true

end

def Placement_un_participant(ID)

	@ID_Var = Participant.find(ID)
	@Creneaux_Non_Dispo = Array.new
	Disponibilite.where(participant_id: @ID_Var).each do |NonDispo|
		if active == 0
			Creneaux_Non_Dispo.push(NonDispo)
		else
			Creneaux_Dispo.push(NonDispo)
		end
	end
	if (Creneaux_Dispo.count == 1) && (Creneaux_Non_Dispo.count < Nombre_de_Creneaux_par_Participant)
		Creneaux_Dispo.first.active = 0
	end

end

def Placement_Tout_Participant
	Participant.each do |p|
		Placement_un_participant(p.ID)
	end
end

def Personnes_Disponibles (creneau)
	@id_c = creneau.id
	@tableau = Array.new
	Participant.each do |p|
		if (Disponibilite.where(participant_id: p.ID, active = 0).count < Nombre_de_Creneaux_par_Participant) && (Disponibilite.where(creneau_id: @id_c).include? p)
			@tableau.push(p)
		end
	end
	return @tableau
end

def creneau_rempli (creneau)
	@id_c = creneau.id
		if Disponibilite.where(creneau_id: @id_c, active = 0).count < creneau.Nombre_de_Participants_Necessaires
			return nil
		end
end

def chaque_creneau_rempli
	Creneau.each do |c|
		if not(creneau_rempli (c))
			return nil
		end
end

def find_min_creneau #Fonction trouver le créneau non rempli avec le minimum de perso dispo (liste Creneaux)
	nb_dispo = Array.new
	i = 0
		Creneau.each do |c|
			if not(creneau_rempli(c))
				nb_dispo[i] = Disponibilite.where(active = 1).count
			end
		end
	return Creneau.find(tab.index(tab.min))
end

def Meilleur_Choix (Liste)
	i = 0
	tableau_restant=Array.new
	Liste.each do |p|
		tableau_restant[i]=Disponibilite.where(participant_id: p.id, active =1).count
		i += 1
	end
	
	tab_min = Array.new
	min = tableau_restant.min
	tableau_restant.each do |t|
		if t == min
			tab_min << tableau_restant.index(t)
		end
	end #Stocke les indexs des plus petits éléments de tableau_restant
	table = Array.new

	Liste.each do |p|
		if tab_min.count > 1
			tab_min.each do |tab|
				a = Disponibilite.where(participant_id: p.id, active =1) 
				table << a.count
					final = tableau.index(table.min)
			end
		else
			final = tableau_restant([tab_min.first]
		end
		return final
	end
end 

def main

	if Event_Valide
		Placement_Tout_Participant

		while not(chaque_creneau_rempli)
			Meilleur_Choix(Personnes_Disponibles(find_min_creneau)).active = 0

		end

	end
end



MAIN :

If(AppelF Creneau_Non_Valide)
	error pas possible
Sinon

AppelF Placement_Participant

TANT_QUE not(chaque creneau rempli (fct)) :

Personne = Disponibilité.where(id=(trouvermachintruc) && active = 1).participants.Meilleur_Choix
Dispo.where(creneau = trouvermachintruc et participant = personne).active = 0
FINTANT_QUE

FINMAIN
