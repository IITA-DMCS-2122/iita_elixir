require 'stripe'
require 'sinatra'

# This is your test secret API key.
Stripe.api_key = 'sk_test_51KIb37L5UfBU9C3e9JjghUN3Kaztq65Mx2Qo5WC8dM7m0luG8qimE50MNv0PTx1jxQ6B5lA5sFPaVTcJamoFtgx2005tlQ64cu'

set :static, true
set :port, 4242

YOUR_DOMAIN = 'http://localhost:4242'



#require 'stripe'
#Stripe.api_key = 'sk_test_51KIb37L5UfBU9C3e9JjghUN3Kaztq65Mx2Qo5WC8dM7m0luG8qimE50MNv0PTx1jxQ6B5lA5sFPaVTcJamoFtgx2005tlQ64cu'
#
#Stripe::Price.create({
#  unit_amount: 2000,
#  currency: 'usd',
#  recurring: {interval: 'day'},
#  product: 'prod_L3OmeuHm56mHmj',
#})


post '/create-checkout-session' do
  content_type 'application/json'

  session = Stripe::Checkout::Session.create({
    line_items: [{
      # Provide the exact Price ID (e.g. pr_1234) of the product you want to sell
      price: "price_1KNI8SL5UfBU9C3eyXCtbYDk",
      quantity: 1,
    }],
    mode: 'payment',
      success_url: YOUR_DOMAIN + '/success.html',
      cancel_url: YOUR_DOMAIN + '/cancel.html',
  })
  redirect session.url, 303
end