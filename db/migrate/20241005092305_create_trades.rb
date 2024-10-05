class CreateTrades < ActiveRecord::Migration[7.2]
  def change
    create_table :trades do |t|
      t.integer :input_good_quantity, null: false
      t.references :input_good, type: :uuid, null: true, foreign_key: {to_table: "goods"}, index: true
      t.integer :output_good_quantity, null: false
      t.references :output_good, type: :uuid, null: true, foreign_key: {to_table: "goods"}, index: true
      t.references :island, type: :uuid, null: true, foreign_key: true, index: true

      t.timestamps
    end

    change_table :available_goods, bulk: true do |t|
      t.rename :export, :island_export
      t.rename :import, :island_import

      t.decimal :dockland_export, null: false, default: 0.0
      t.decimal :dockland_import, null: false, default: 0.0
    end
  end
end
