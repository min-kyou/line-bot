require 'net/http'
require 'open-uri'
require 'json'
require 'logger'
require 'nokogiri'
require 'line/bot'
Bundler.require

# 引っかかったこと このクラス名はファイル名と合わせないとエラーをはく（あほ）
# 401が出続ける→herokuのurlを間違えていた
# 404が出続ける→/callbackを叩いた際のアクションが未定義だった（ばか）
# ActionController::InvalidAuthenticityToken (Can't verify CSRF token authenticity.)→
class Batch::LineBotBatch

  def self.run
    #################################
    # qiita関連
    #################################
    # qiitaの週間トレンド記事ページからDOMを取得
    url = 'https://qiita.com/Qiita/items/b5c1550c969776b65b9b'
    # 引っかかったこと1 res = open(url) だと`initialize': No such file or directory @ rb_sysopen のエラーがでる
    res = URI.open(url)
    res_body = res.read

    charset = res.charset
    html = Nokogiri::HTML.parse(res_body, nil, charset)

    # 目的のidを持つ要素とその子要素を取得
    target_id = "#personal-public-article-body"
    body = html.css(target_id)

    # h3タグ以下を取得
    title_array = body.xpath("//h3")

    #################################
    # line-bot関連
    #################################
    # クライアント作成
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    # 自分のuserId
    user_id = ENV["LINE_MY_ID"]

    #################################
    # メッセージを作ってpush通知で送信
    #################################
    i = 0
    body.css('h3 ~ p').each do |node1|

      if node1.children.css('img')[0].attribute('alt').value == ":new:"
        # 記事url
        article_url = title_array[i].children.css('a')[1].attribute('href').text
        # 本文作成
        message = {
          type: 'text',
          text: article_url
        }

        # プッシュ通知を送信
        client.push_message(user_id, message)
      end
      "OK"
      i += 1
    end

  end
end