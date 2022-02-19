class AddExports < ActiveRecord::Migration[7.0]
  def change
    create_table :exports, id: :uuid do |t|
      t.decimal :quantity
      t.references :local_produced_good, type: :uuid, null: false, foreign_key: true, index: true
      t.references :island, type: :uuid, null: false, foreign_key: true, index: true

      t.timestamps
    end

    change_table :available_goods, bulk: true do |t|
      t.decimal :export, null: false, default: 0.0
      t.decimal :import, null: false, default: 0.0
    end
  end
end
