require 'twitter'
require 'tweetstream'
require 'pp'
require 'csv'

CONSUMER_KEY = "zoUduSlLN1hb00oTdNPNDQ"
CONSUMER_SECRET = "r0hxehpzcwehokoNoZlD2C0XWk6CIGMYGP1YG2A"
OAUTH_TOKEN = "922375742-scec0SLSAmPp08hbCJCroC6HhjKKmDU6ymUg1yQT"
OAUTH_TOKEN_SECRET = "w9r4nH5YoaadwaSfBN9MNlA4w3QMHKlKmTdwDkGHI"

class TwitterResponder
  
  def initialize
    @shakes = CSV.read('shakespeare.csv')
    Twitter.configure do |config|
      config.consumer_key       = CONSUMER_KEY
      config.consumer_secret    = CONSUMER_SECRET
      config.oauth_token        = OAUTH_TOKEN
      config.oauth_token_secret = OAUTH_TOKEN_SECRET
    end
    TweetStream.configure do |config|
      config.consumer_key       = CONSUMER_KEY
      config.consumer_secret    = CONSUMER_SECRET
      config.oauth_token        = OAUTH_TOKEN
      config.oauth_token_secret = OAUTH_TOKEN_SECRET
      config.auth_method        = :oauth
    end
    listen
  end

  def listen
    TweetStream::Client.new.track('#dbc_c4') do |status|
      response(status.user[:screen_name])
    end  
  end

  def response(respond_to, response = craft_response)
    Twitter.update("@#{respond_to} #{response}, \##{response.split(' ')[1]}  :)")
  end

  def craft_response(phrase = [])
    (0..2).each {|i| phrase << @shakes[rand(1..@shakes.length - 1)][i]}
    phrase.insert(0,"Thou").join(' ')
  end

end

tw_bot = TwitterResponder.new
