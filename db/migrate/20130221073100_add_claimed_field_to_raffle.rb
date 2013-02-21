class AddClaimedFieldToRaffle < ActiveRecord::Migration
  def change
	change_table :raffles do |t|
		t.boolean :claimed
	end
  end
end
