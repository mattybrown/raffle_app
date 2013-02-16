class RafflesController < ApplicationController

  def new
	@raffle = Raffle.new
  end

  def create
	dirty_tickets = params[:number]
	tickets = dirty_tickets.to_i
	name = params[:name]
	ticket_and_code = []

	base_val = 1

	for i in (base_val..tickets)
		tickets = []
		ticket = name + i.to_s
		code = (1..9).to_a.shuffle[0..6].join
		tickets.push ticket, code
		ticket_and_code.push tickets
	end

	@raffle = Raffle.new(:tickets => ticket_and_code, :name => name)
	  if @raffle.save
	    flash[:notice] = "Raffle created"
	  else	
	    flash[:notice] = "Trouble!"
	  end
	render "new"
  end

  def show
  	@last_raffle = Raffle.last

  end

  def draw
	ticket_array = Raffle
  end

end
