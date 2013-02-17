class AddNumberOfTicketsToRaffles < ActiveRecord::Migration
  def change
	change_table :raffles do |t|
		t.string :number
	end
  end
end
