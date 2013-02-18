class Raffle < ActiveRecord::Base
  attr_accessible :tickets, :winner, :name, :number, :id

  serialize :tickets

end
