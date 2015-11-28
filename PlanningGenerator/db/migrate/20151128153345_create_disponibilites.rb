class CreateDisponibilites < ActiveRecord::Migration
  def change
    create_table :disponibilites do |t|
      t.belongs_to :creneau, index: true
      t.belongs_to :participant, index: true
      t.integer :active
      t.timestamps null: false
    end
  end
end
