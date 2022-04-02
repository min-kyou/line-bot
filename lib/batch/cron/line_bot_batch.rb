require 'net/http'
require 'uri'
require 'json'
require 'logger'

class Batch::Cron::SampleBatch
  def initialize
    logger = Logger.new('../../../log/api.log')

  end

  def exec

  end
end