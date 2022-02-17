class AddIslands < ActiveRecord::Migration[7.0]
  def change
    create_table :islands, id: :uuid do |t|
      t.string :name, null: false
      t.references :game, type: :uuid, null: false, foreign_key: true, index: true
      t.references :region, type: :uuid, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
