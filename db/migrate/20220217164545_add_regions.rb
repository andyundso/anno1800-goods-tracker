class AddRegions < ActiveRecord::Migration[7.0]
  def change
    create_table :regions, id: :uuid do |t|
      t.timestamps
    end
  end
end
