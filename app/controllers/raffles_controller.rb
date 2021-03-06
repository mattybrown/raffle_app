class RafflesController < ApplicationController
before_filter :authenticate, :except => [:index, :winner]
require 'mail'

  def new
	@raffle = Raffle.new
  end

  def create
	prize = params[:prize]
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

	@raffle = Raffle.new(:tickets => ticket_and_code, :name => name, :number => ticket_num, :prize => prize, :claimed => false)
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
	if params[:commit]
		@last_raffle = Raffle.last
		@max_range = Integer(@last_raffle.number) - 1
		draw_range = (1..@max_range).to_a.shuffle
		number = Integer(draw_range[0])
		@sanitized_winner = @last_raffle.tickets[number][0]
		@last_raffle.winner = @sanitized_winner
		@last_raffle.save
	end
	@winner = @sanitized_winner
  end

  def index
	@all_raffles = Raffle.all
	@last_raffle = Raffle.last
	ticket = params[:ticket]
	unique_id = params[:unique_identifier].to_i
	if params[:commit]
		if unique_id != 0
			@last_raffle.tickets.each do |i|
				match = i[0].to_s
				id = i[1].to_s		
				if ticket == match && unique_id.to_s == id
					if ticket == @last_raffle.winner
						flash.now[:notice] = "Congratulations, you won!"
						render "congrats"
						break
					else
						flash.now[:notice] = "Thanks for entering, but sorry, that ticket wasn't a winner. Try again next time!"
						break
					end
				elsif ticket != match || unique_id.to_s != id
					flash.now[:error] = "Your ticket doesn't match your unique id!"
				end
			end
		else
			flash.now[:notice] = "Your unique id is invalid "
		end
	end
  end

  def winner
Mail.defaults do
  delivery_method :smtp, {
    :port      => 587,
    :address   => "smtp.mandrillapp.com",
    :user_name => APP_CONFIG[:mandrill_username],
    :password  => APP_CONFIG[:mandrill_password]
  }
end
	@last_raffle = Raffle.last
	if params[:commit]
		name = params[:name]
		email = params[:email]
		if validate_email(email)
			mail = Mail.deliver do
				to	'brownprobable@gmail.com'
				from	'Raffle Notification <raffles@mattybrown.net>'
				subject	'Raffle winner has claimed their prize'

				html_part do
					content_type 'text/html; charset=UTF-8'
					body 'The winner is, ' + name + ', and their email is, ' + email
				end
			end
			if mail.action == 'failed'
				render "email_fail"

			else
				render "email_success"
				@last_raffle.claimed = true
				@last_raffle.save
			end
		else
			flash.now[:notice] = "Please enter a valid email address"
			render "congrats"
		end
	end
  end
protected

def validate_email(email)
  
  email_regex = %r{
    ^ # Start of string
    [0-9a-z] # First character
    [0-9a-z.+]+ # Middle characters
    [0-9a-z] # Last character
    @ # Separating @ character
    [0-9a-z] # Domain name begin
    [0-9a-z.-]+ # Domain name middle
    [0-9a-z] # Domain name end
    $ # End of string
  }xi # Case insensitive
  
  if email =~ email_regex
    return true
  else
    return false
  end
end
end
