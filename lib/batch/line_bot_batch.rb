require 'net/http'
require 'open-uri'
require 'json'
require 'logger'
require 'nokogiri'
require 'line/bot'
Bundler.require

# 引っかかったこと このクラス名はファイル名と合わせないとエラーをはく（あほ）
class Batch::LineBotBatch
  def initialize
    # logger = Logger.new('../../../log/api.log')

  end

  def self.run
    url = 'https://qiita.com/Qiita/items/b5c1550c969776b65b9b'
    # 引っかかったこと1 res = open(url) だと`initialize': No such file or directory @ rb_sysopen のエラーがでる
    res = URI.open(url)
    body = res.read

    charset = res.charset
    html = Nokogiri::HTML.parse(body, nil, charset)

    target_id = "#personal-public-article-body"
    body = html.css(target_id)

    # line-botのクライアント作成
    # client = create_client
    #
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    # num_array = []
    i = 0
    # h3タグ以下を取得
    title_array = body.xpath("//h3")

    body.css('h3 ~ p').each do |node1|

      if node1.children.css('img')[0].attribute('alt').value == ":new:"
        # imgのalt属性にnewを持つ記事の番号を記憶
        # num_array.push(i)

        # 記事タイトル
        # article_title = title_array[i].children.css('a')[1].text
        # 記事url
        article_url = title_array[i].children.css('a')[1].attribute('href').text
      end
      i += 1

      uri = URI('https://blueberry-custard-37486.herokuapp.com/callback')
      params = {
      }
      request = Net::HTTP.post_form(uri, params)
      
      # request = post('https://git.heroku.com/blueberry-custard-37486.git/callback')
      # ラインapi
      body = request.body
      pp "===========-body"
      pp request
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
    # pp num_array

  end

  # def create_client
  #   @client ||= Line::Bot::Client.new { |config|
  #     config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
  #     config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  #   }
  # end
  #
  # def callback(article_url)
  #   body = request.body.read
  #   signature = request.env['HTTP_X_LINE_SIGNATURE']
  #   unless client.validate_signature(body, signature)
  #     halt 400, {'Content-Type' => 'text/plain'}, 'Bad Request'
  #   end
  #   events = client.parse_events_from(body)
  #
  #   events.each do |event|
  #     pp event
  #     case event
  #     when Line::Bot::Event::Message
  #       case event.type
  #       when Line::Bot::Event::MessageType::Text
  #         # メッセージ作成
  #         message = {
  #           type: 'text',
  #           text: article_url
  #         }
  #
  #         response = client.push_message("<to>", message)
  #       end
  #     end
  #   end
  #
  #   "OK"
  # end
end