class Creneau < ActiveRecord::Base
	belongs_to :event
	has_many :participants, :through => :disponibilites
	validates_associated :event
	validates :date_fin, :presence => "true"
	validates :date_debut, :presence => "true"
	validates :Nombre_de_Participants_Necessaires, presence: true
end
