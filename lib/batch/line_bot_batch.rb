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
    result = html.css(target_id)

    num_array = []
    # もしimgのalt属性にnewを持つ奴がいたら
    html.css('#personal-public-article-body').each do |node|
      i = 1
      node.css('h3 ~ p').each do |node1|
        #
        # pp "================"
        # pp node1.children.css('img')[0]
        # pp node1.children.css('img')[0].attributes
        # pp node1.children.css('img')[0].attribute('alt').value == ":new:"
        # pp i

        if node1.children.css('img')[0].attribute('alt').value == ":new:"
          # 番号を記憶
          num_array.push(i)
        end
        i += 1
      end
    end

    num_array.each do |num|
      body = html.css('#personal-public-article-body')
      
    end
  end
end