class AddAvailableGood < ActiveRecord::Migration[7.0]
  def change
    create_table :available_goods, id: :uuid do |t|
      t.decimal :consumption, null: false, default: 0.0
      t.decimal :production, null: false, default: 0.0

      t.references :island, type: :uuid, null: false, foreign_key: true, index: true
      t.references :good, type: :uuid, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
