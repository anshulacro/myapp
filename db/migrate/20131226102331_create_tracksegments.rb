class CreateTracksegments < ActiveRecord::Migration
  def change
    create_table :tracksegments do |t|
      t.references :track

      t.timestamps
    end
    add_index :tracksegments, :track_id
  end
end
