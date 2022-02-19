class AddLocalProducedGoods < ActiveRecord::Migration[7.0]
  def change
    create_table :local_produced_goods, id: :uuid do |t|
      t.decimal :production
      t.decimal :consumption

      t.references :island, type: :uuid, null: false, foreign_key: true, index: true
      t.references :good, type: :uuid, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
