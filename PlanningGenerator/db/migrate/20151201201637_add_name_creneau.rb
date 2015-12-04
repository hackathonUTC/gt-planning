class AddNameCreneau < ActiveRecord::Migration
  def change
  	change_table :creneaus do |t|
	    t.string :nom_creneau
	 end
  end
end
