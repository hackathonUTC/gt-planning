class Event < ActiveRecord::Base
	has_many :creneaus
	has_many :participants
	accepts_nested_attributes_for :creneaus
end
