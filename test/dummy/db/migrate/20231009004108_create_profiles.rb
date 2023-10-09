class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.integer :age
      t.date :birthdate

      t.timestamps
    end
  end
end
