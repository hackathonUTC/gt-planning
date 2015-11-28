class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :nom
      t.belongs_to :event, index: true

      t.timestamps null: false
    end
  end
end
