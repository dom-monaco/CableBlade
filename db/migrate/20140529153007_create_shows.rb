class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :name
      t.references :network, index: true
      t.boolean :hulu
      t.boolean :netflix
      t.decimal :itunes, precision: 5, scale: 2
      t.decimal :amazon, precision: 5, scale: 2

      t.timestamps
    end
  end
end
