class CreateSites < ActiveRecord::Migration
  def change
    create_table(:sites) do |t|
      t.string :site_name, :null => false
      t.string :measurement_type, :null => false
      t.timestamps
    end
  end
end
