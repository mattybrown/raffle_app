# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RaffleApp::Application.initialize!

config.action_mailer.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address  => "smtp.mandrillapp.com",
  :port  => 587,
  :user_name  => "app12026576@heroku.com",
  :password  => "bTbc2MAJJJtrLfzP0lxt8w",
  :authentication  => :login
}

config.action_mailer.raise_delivery_errors = true
