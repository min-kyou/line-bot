require 'net/http'
require 'open-uri'
require 'json'
require 'logger'
require 'nokogiri'
require 'line/bot'
Bundler.require

# webhookを叩いた時のアクションを定義するコントローラ

class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def callback

    body2 = request.body.read

    url = 'https://qiita.com/Qiita/items/b5c1550c969776b65b9b'

    res = URI.open(url)
    body = res.read

    charset = res.charset
    html = Nokogiri::HTML.parse(body, nil, charset)

    target_id = "#personal-public-article-body"
    body = html.css(target_id)

    i = 0

    # h3タグ以下を取得
    title_array = body.xpath("//h3")

    # line-apiのクライアント取得
    client = create_client

    body.css('h3 ~ p').each do |node1|
      if node1.children.css('img')[0].attribute('alt').value == ":new:"
        # imgのalt属性にnewを持つ記事の番号を記憶
        # num_array.push(i)

        # 記事タイトル
        # article_title = title_array[i].children.css('a')[1].text
        # 記事url
        article_url = title_array[i].children.css('a')[1].attribute('href').text


        signature = request.env['HTTP_X_LINE_SIGNATURE']
        pp "===========-body"
        pp body2
        pp signature


        unless client.validate_signature(body2, signature)
          error 400 do 'Bad Request' end
        end

        events = client.parse_events_from(body2)

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

  end

  private 
  
  def create_client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end