class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.references :tracksegment
      t.string :name
      t.float :latitude
      t.float :longitude
      t.float :elevation
      t.string :description
      t.datetime :point_created_at

      t.timestamps
    end
    add_index :points, :tracksegment_id
  end
end
