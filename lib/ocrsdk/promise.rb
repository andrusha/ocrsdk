class OCRSDK::Promise < OCRSDK::AbstractEntity
  include OCRSDK::Verifiers::Status

  attr_reader :task_id, :status, :result_urls, :estimate_processing_time

  def self.from_response(xml_string)
    OCRSDK::Promise.new(nil).parse_response xml_string
  end

  def initialize(task_id)
    super()
    @task_id = task_id
  end

  def estimate_completion
    @registration_time + @estimate_processing_time.seconds
  end

  def parse_response(xml_string)
    xml = Nokogiri::XML.parse xml_string
    begin
      task = xml.xpath('/response/task').first
      @task_id = task['id']
    rescue NoMethodError # if Nokogiri can't find root node
      raise OCRSDK::OCRSDKError, "Problem parsing provided xml string: #{xml_string}"
    end

    @status     = status_to_sym task['status']
    @result_urls = [task['resultUrl'], task['resultUrl2'], task['resultUrl3']]
    @registration_time        = DateTime.parse task['registrationTime']    
    @estimate_processing_time = task['estimatedProcessingTime'].to_i

    # admin should be notified in this case
    raise OCRSDK::NotEnoughCredits  if @status == :not_enough_credits

    self
  end

  def update(retry_sleep=OCRSDK.config.retry_wait_time)
    retryable tries: OCRSDK.config.number_or_retries, on: OCRSDK::NetworkError, sleep: retry_sleep do
      parse_response api_update_status
    end
  end

  def completed?
    @status == :completed
  end

  def failed?
    [:processing_failed, :deleted, :not_enough_credits].include? @status
  end

  def processing?
    [:submitted, :queued, :in_progress].include? @status
  end

  def result(retry_sleep=OCRSDK.config.retry_wait_time)
    result_with_number(0, retry_sleep)
  end

  def result2(retry_sleep=OCRSDK.config.retry_wait_time)
    result_with_number(1, retry_sleep)
  end

  def result3(retry_sleep=OCRSDK.config.retry_wait_time)
    result_with_number(2, retry_sleep)
  end

  def result_with_number(number, retry_sleep)
    raise OCRSDK::ProcessingFailed  if failed?
    retryable tries: OCRSDK.config.number_or_retries, on: OCRSDK::NetworkError, sleep: retry_sleep do
      api_get_result(number)
    end
  end

  def wait(seconds=OCRSDK.config.default_poll_time)
    while processing? do
      sleep seconds
      update
    end

    self
  end

private

  # http://ocrsdk.com/documentation/apireference/getTaskStatus/
  def api_update_status
    params = URI.encode_www_form taskId: @task_id
    uri    = URI.join @url, '/getTaskStatus', "?#{params}"

    RestClient.get uri.to_s
  rescue RestClient::ExceptionWithResponse
    raise OCRSDK::NetworkError
  end

  def api_get_result(result_number=0)
    RestClient.get @result_urls[result_number].to_s
  rescue RestClient::ExceptionWithResponse
    raise OCRSDK::NetworkError
  end

end
