class RafflesController < ApplicationController
before_filter :authenticate, :except => :index
  def new
	@raffle = Raffle.new
  end

  def create
	dirty_tickets = params[:number]
	ticket_num = dirty_tickets.to_i
	name = params[:name]
	ticket_and_code = []

	base_val = 1

	for i in (base_val..ticket_num)
		tickets = []
		ticket = name + i.to_s
		code = (1..9).to_a.shuffle[0..6].join
		tickets.push ticket, code
		ticket_and_code.push tickets
	end

	@raffle = Raffle.new(:tickets => ticket_and_code, :name => name, :number => ticket_num)
	  if @raffle.save
	    flash[:notice] = "Raffle created"
	  else	
	    flash[:notice] = "Trouble!"
	  end
	render "new"
  end

  def show
  	@last_raffle = Raffle.last
	@name = @last_raffle.name
  end

  def draw
	@last_raffle = Raffle.last
	@max_range = Integer(@last_raffle.number) - 1
	draw_range = (1..@max_range).to_a.shuffle
	number = Integer(draw_range[0])
	@winner = @last_raffle.tickets[number]
	@sanitized_winner = @winner[0]
	@last_raffle.winner = @sanitized_winner
	@last_raffle.save
  end

  def index
	@last_raffle = Raffle.last
	ticket = params[:ticket]
	unique_id = params[:unique_identifier].to_i
	if params[:commit]
		if unique_id.is_a? Integer
			@last_raffle.tickets.each do |i|
				match = i[0].to_s
				id = i[1].to_s		
				if ticket == match && unique_id.to_s == id
					flash.now[:notice] = "Congratulations, you won!"
					render "congrats"
					break
				else
					flash.now[:notice] = "Sorry, that ticket wasn't a winner. Try again next time!"
				end
			end
		else
			flash.now[:notice] = "Your unique id is invalid " + unique_id 
		end
	end
  end

  def winner
	@last_raffle = Raffle.last
  end

end
