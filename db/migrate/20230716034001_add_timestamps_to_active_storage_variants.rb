class AddTimestampsToActiveStorageVariants < ActiveRecord::Migration[7.0]
  def change
    change_table :active_storage_variant_records do |t|
      t.timestamps
    end
  end
end
