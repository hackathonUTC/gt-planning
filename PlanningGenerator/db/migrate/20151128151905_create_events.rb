class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :Nom
      t.integer :Nombre_de_Creneaux
      t.integer :Nombre_de_Participants
      t.integer :Nombre_de_Creneaux_par_Participant

      t.timestamps null: false
    end
  end
end
