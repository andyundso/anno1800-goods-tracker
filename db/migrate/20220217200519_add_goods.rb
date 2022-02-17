class AddGoods < ActiveRecord::Migration[7.0]
  def change
    create_table :goods, id: :uuid do |t|
      t.timestamps
    end
  end
end
