require 'net/http'
require 'open-uri'
require 'json'
require 'logger'
require 'nokogiri'

class Batch::Cron::SampleBatch
  def initialize
    logger = Logger.new('../../../log/api.log')

  end

  def exec
    url = 'https://qiita.com/Qiita/items/b5c1550c969776b65b9b'
    res = open(url)

    body = res.read

    charset = res.charset
    html = Nokogiri::HTML.parse(body, nil, charset)

  end
end