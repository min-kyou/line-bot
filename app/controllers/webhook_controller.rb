# webhookを叩いた時のアクションを定義するコントローラ

class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def callback
    body = request.body
    pp "===========-body"
    pp body
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      halt 400, {'Content-Type' => 'text/plain'}, 'Bad Request'
    end
    events = client.parse_events_from(body)

    events.each do |event|
      pp event
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          # メッセージ作成
          message = {
            type: 'text',
            text: article_url
          }

          response = client.push_message("<to>", message)
          pp response
        end
      end
    end

    "OK"
  end
end