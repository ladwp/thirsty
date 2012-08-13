class CreateSamples < ActiveRecord::Migration
  def change
    create_table(:samples) do |t|
      t.float :value, :null => false
      t.belongs_to :site, :null => false
      t.datetime :sampled_at, :null => false
      t.timestamps
    end
    add_index :samples, :sampled_at
    add_index :samples, [:sampled_at, :site_id], :unique => true
  end
end
