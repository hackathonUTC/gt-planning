class AddEndDateToCreneauAndChangeDateName < ActiveRecord::Migration
  def change
  	change_table :creneaus do |t|
	    t.remove :date
	    t.datetime :date_debut, :date_fin
  	end
  end
end
