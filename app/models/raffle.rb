class Raffle < ActiveRecord::Base
  attr_accessible :tickets, :winner, :name

  serialize :tickets
end
