class Event < ActiveRecord::Base
	has_many :creneaus
	has_many :participants
end
