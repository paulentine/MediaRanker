class AddDeletedColumnToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :deleted, :boolean, default: false
  end
end
