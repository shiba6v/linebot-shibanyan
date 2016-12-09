require 'rubygems'
require 'sinatra'
require 'line/bot'
require 'active_record'
require './user.rb'
require 'sqlite3'

get '/' do
	'yes'
end

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each { |event|
  	puts "------"
  	p event
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text'] + "💕"
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
    when Line::Bot::Event::Beacon
    	p "beacon ok"
      	p event['beacon']['hwid']
        message = {
          type: 'text',
          text: "わいわい"
        }
        client.reply_message(event['replyToken'], message)
    end
  }

  "OK"
end