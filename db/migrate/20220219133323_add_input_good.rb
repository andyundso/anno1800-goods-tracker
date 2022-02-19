class AddInputGood < ActiveRecord::Migration[7.0]
  def change
    create_table :input_goods, id: :uuid do |t|
      t.references :input_good, type: :uuid, foreign_key: {to_table: "goods"}, null: false, index: true
      t.references :output_good, type: :uuid, foreign_key: {to_table: "local_produced_goods"}, null: false, index: true

      t.timestamps
    end

    add_column :available_goods, :local_usage, :decimal
  end
end
