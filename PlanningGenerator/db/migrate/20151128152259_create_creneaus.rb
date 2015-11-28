class CreateCreneaus < ActiveRecord::Migration
  def change
    create_table :creneaus do |t|
      t.datetime :date
      t.integer :Nombre_de_Participants_Necessaires
      t.belongs_to :event, index: true

      t.timestamps null: false
    end
  end
end
