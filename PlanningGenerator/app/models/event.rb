class Event < ActiveRecord::Base
	has_many :creneaus
	has_many :participants
	validates :Nom, presence: true
	validates :Nombre_de_Creneaux, numericality: true, presence: true
	validates :Nombre_de_Participants, numericality: true, presence: true
	validates :Nombre_de_Creneaux_par_Participant, numericality: true, presence: true
	accepts_nested_attributes_for :creneaus
	accepts_nested_attributes_for :participants
end
