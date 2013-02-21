class RaffleWinner < ActionMailer::Base
  default from: "raffles@mattybrown.net"

  def email_winner(email)
	@winner = email
	mail(:to => email, :subject => "Your prize voucher!")
  end
end
