class Participant < ActiveRecord::Base
	belongs_to :event
	has_many :creneaus, :through => :disponibilites
	validates_associated :event
	validates :nom, presence: true
end
