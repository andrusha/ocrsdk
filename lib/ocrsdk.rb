require 'cgi'
require 'uri'
require 'nokogiri'
require 'pdf-reader'
require 'rest-client'
require 'active_support/inflector'
require 'active_support/time'
require 'active_support/configurable'

# http://ocrsdk.com/documentation/apireference/
module OCRSDK
  include ActiveSupport::Configurable

  DEFAULT_POLL_TIME = 3
  SERVICE_URL = 'cloud.ocrsdk.com'

  def self.setup
    yield config
  end
end

require 'ocrsdk/errors'
require 'ocrsdk/verifiers'
require 'ocrsdk/abstract_entity'
require 'ocrsdk/image'
require 'ocrsdk/pdf'
require 'ocrsdk/document'
require 'ocrsdk/promise'
