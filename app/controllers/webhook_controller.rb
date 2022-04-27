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
  protect_from_forgery except: [:callback]
  
  def callback
    #
    # body2 = request.body.read
    #
    # # line-apiのクライアント取得
    # client = create_client
    # events = client.parse_events_from(body2)
    #
    # # 自分のuserId
    # user_id = ENV["LINE_MY_ID"]
    #
    # # userId取得時に使ったコード
    # # events.each do |event|
    # #   user_id = event['source']['userId']  #user_id取得
    # #   pp "============--userid"
    # #   pp 'UserID: ' + user_id # user_id
    # # end
    #
    # signature = request.env['HTTP_X_LINE_SIGNATURE']
    # pp "===========request"
    # pp request
    # pp request.body
    # pp body2
    # pp signature
    #
    # #####################
    # # 記事取得系
    # #######################
    # url = 'https://qiita.com/Qiita/items/b5c1550c969776b65b9b'
    #
    # res = URI.open(url)
    # body = res.read
    #
    # charset = res.charset
    # html = Nokogiri::HTML.parse(body, nil, charset)
    #
    # target_id = "#personal-public-article-body"
    # body = html.css(target_id)
    #
    # i = 0
    #
    # # h3タグ以下を取得
    # title_array = body.xpath("//h3")
    # # ##############################################
    # #
    # body.css('h3 ~ p').each do |node1|
    #   if node1.children.css('img')[0].attribute('alt').value == ":new:"
    #     # imgのalt属性にnewを持つ記事の番号を記憶
    #     # num_array.push(i)
    #
    #     # 記事タイトル
    #     # article_title = title_array[i].children.css('a')[1].text
    #     # 記事url
    #     article_url = title_array[i].children.css('a')[1].attribute('href').text
    #
    #
    #     unless client.validate_signature(body2, signature)
    #       error 400 do 'Bad Request' end
    #     end
    #
    #     events.each do |event|
    #       pp "=============event1"
    #       pp event
    #       case event
    #       when Line::Bot::Event::Message
    #         case event.type
    #         when Line::Bot::Event::MessageType::Text
    #           # メッセージ作成
    #           message = {
    #             type: 'text',
    #             text: article_url
    #           }
    #
    #           response = client.push_message(user_id, message)
    #           pp response
    #         end
    #       end
    #     end
    #
    #     "OK"
    #   end
    # end
    # "OK"
  end

  private 
  #
  # def create_client
  #   @client ||= Line::Bot::Client.new { |config|
  #     config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
  #     config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  #   }
  # end
end