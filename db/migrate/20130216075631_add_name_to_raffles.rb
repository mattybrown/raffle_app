class AddNameToRaffles < ActiveRecord::Migration
  def change
	change_table :raffles do |t|
		t.string :name
	end
  end
end
