class RemoveNomCreneau < ActiveRecord::Migration
  def change
    remove_column :creneaus, :nom_creneau, :string
  end
end
