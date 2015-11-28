tableau = Array.new
Tableau_Non_remplis = Array.new

Disponibilite.where(active == 0).each do |disponibilite|
	if creneau.ID.count(disponibilite.creneau.ID) != creneau.find(disponibilite.creneau.ID).Nb_Participants
		Tableau_Non_remplis.push(creneau.disponibilite)
	end
end
#Sort un tableau contenant les Creneaux qui ont active = 0

#Deuxième étape : Sortir l'ID_Tableau qui revient le moins souvent


Creneau.each do |creneau|
 	if (creneau.disponibilites.where(active == 0).count < Nb_Participants)
 		creneau.disponibilites.where(active == 1).each do |disponibilite|
 			tableau.push(disponibilite.creneau)
 		end
 	end
 end
 
scafall

#Je récupère donc un tableau des créneaux restants à compléter

tableau.disponibilite.count



