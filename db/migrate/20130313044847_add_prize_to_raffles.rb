class AddPrizeToRaffles < ActiveRecord::Migration
  def change
	change_table :raffles do |t|
		t.string :prize
	end
  end
end
