require 'ocrsdk'
require 'webmock'

module OCRSDK::Mock
  MOCKS_PATH = File.realpath(File.join(File.dirname(__FILE__), '..', '..', 'mocks'))

  class << self
    def success
      stub_process_image response(:process_image, :success)
      stub_get_task_status response(:get_task_status, :completed)
      stub_result response(:result, :simple)
      stub_result response(:result2, :simple2),'http://cloud.ocrsdk.com/result_url2'
      stub_result response(:result3, :simple3),'http://cloud.ocrsdk.com/result_url3'
    end

    def in_progress
      success
      stub_get_task_status response(:get_task_status, :in_progress)
    end

    def not_enough_credits
      success
      stub_process_image response(:process_image, :not_enough_credits)
      stub_get_task_status response(:get_task_status, :not_enough_credits)
    end

    def stub_process_image(response)
      WebMock::API.stub_request(:post, /.*:.*@cloud.ocrsdk.com\/processImage/).to_return(body: response)
    end

    def stub_get_task_status(response)
      WebMock::API.stub_request(:get,  /.*:.*@cloud.ocrsdk.com\/getTaskStatus\?taskId=.*/).to_return(body: response)
    end

    def stub_result(response, url = "http://cloud.ocrsdk.com/result_url")
      WebMock::API.stub_request(:get, url).to_return(body: response)
    end

    def response(method, status)
      path = File.join(MOCKS_PATH, method.to_s, "#{status.to_s}.xml")

      unless File.exist? path
        warn "No predefined xml response for #{method}/#{status} found. Path: #{path}"
      end

      File.new(path).read
    end    
  end
end
