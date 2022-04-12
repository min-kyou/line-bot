require 'net/http'
require 'open-uri'
require 'json'
require 'logger'
require 'nokogiri'

# 引っかかったこと このクラス名はファイル名と合わせないとエラーをはく（あほ）
class Batch::LineBotBatch
  # def initialize
  #   logger = Logger.new('../../../log/api.log')
  #
  # end

  def self.run
    url = 'https://qiita.com/Qiita/items/b5c1550c969776b65b9b'
    # 引っかかったこと1 res = open(url) だと`initialize': No such file or directory @ rb_sysopen のエラーがでる
    res = URI.open(url)
    body = res.read

    charset = res.charset
    html = Nokogiri::HTML.parse(body, nil, charset)

    target_id = "#personal-public-article-body"
    body = html.css(target_id)

    num_array = []
    i = 0
    body.css('h3 ~ p').each do |node1|

      if node1.children.css('img')[0].attribute('alt').value == ":new:"
        # imgのalt属性にnewを持つ記事の番号を記憶
        num_array.push(i)
      end
      i += 1
    end
    # pp num_array

    num_array.each do |num|
      # h3タグ以下を取得
      title_array = body.xpath("//h3")
      # 記事タイトル
      article_title = title_array[num].children.css('a')[1].text
      # 記事url
      article_url = title_array[num].children.css('a')[1].attribute('href').text

    end
  end
end