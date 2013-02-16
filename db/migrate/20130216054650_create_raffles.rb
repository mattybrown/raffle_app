class CreateRaffles < ActiveRecord::Migration
  def change
    create_table :raffles do |t|
	t.text :tickets
	t.string :winner
      t.timestamps
    end
  end
end
