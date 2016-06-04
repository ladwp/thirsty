class IndexSampleOnSiteId < ActiveRecord::Migration
  def up
    add_index :samples, :site_id
  end

  def down
    remove_index :samples, :site_id
  end
end
