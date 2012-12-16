require 'cgi'
require 'uri'
require 'nokogiri'
require 'retryable'
require 'pdf-reader'
require 'rest-client'
require 'active_support/inflector'
require 'active_support/time'
require 'active_support/configurable'

# http://ocrsdk.com/documentation/apireference/
module OCRSDK
  include ActiveSupport::Configurable

  def self.setup
    yield config
  end
end

# Default configuration values
OCRSDK.setup do |config|
  # These two should be set by user
  config.application_id = nil
  config.password       = nil

  # Generally this is not the thing you would want to change
  # but in some rare cases like access to test servers
  # it might be useful
  config.service_url = 'cloud.ocrsdk.com'

  # How much time in seconds wait between requests
  config.default_poll_time = 3 # seconds

  # How many times retry before rendering request as failed
  config.number_or_retries = 3 # times
  # How much time wait before retries
  config.retry_wait_time   = 3 # seconds
end

require 'ocrsdk/errors'
require 'ocrsdk/verifiers'
require 'ocrsdk/abstract_entity'
require 'ocrsdk/image'
require 'ocrsdk/pdf'
require 'ocrsdk/document'
require 'ocrsdk/promise'
