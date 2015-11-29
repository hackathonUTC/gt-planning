class Disponibilite < ActiveRecord::Base
	belongs_to :creneau
	belongs_to :participant
	validates_associated :creneau
	validates_associated :participant
	#validates :active, presence: true
end
