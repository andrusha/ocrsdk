require 'cgi'
require 'uri'
require 'nokogiri'
require 'pdf-reader'
require 'rest-client'
require 'active_support/inflector'
require 'active_support/time'

# http://ocrsdk.com/documentation/apireference/
module OCRSDK
  DEFAULT_POLL_TIME = 3
  SERVICE_URL = 'cloud.ocrsdk.com'
end

require 'ocrsdk/errors'
require 'ocrsdk/verifiers'
require 'ocrsdk/abstract_entity'
require 'ocrsdk/image'
require 'ocrsdk/pdf'
require 'ocrsdk/document'
require 'ocrsdk/promise'
