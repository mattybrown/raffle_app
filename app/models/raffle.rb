class Raffle < ActiveRecord::Base
  attr_accessible :tickets, :winner, :name, :number, :id, :claimed, :prize

  serialize :tickets

end
