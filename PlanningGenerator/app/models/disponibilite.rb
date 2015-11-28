class Disponibilite < ActiveRecord::Base
	validates_associated :creneau
	validates_associated :participant
	validates :active, presence: true
end
