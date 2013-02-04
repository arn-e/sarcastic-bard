require 'twitter'
require 'tweetstream'
require 'pp'
require 'csv'

class TwitterResponder
  
  def initialize
    @shakes = CSV.read('./lib/shakespeare.csv')
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
    TweetStream::Client.new.track('#some_hash_tag') do |status|
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
