class OCRSDK::Promise < OCRSDK::AbstractEntity
  include OCRSDK::Verifiers::Status

  attr_reader :task_id, :status, :result_url, :estimate_processing_time

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
    @result_url = task['resultUrl']
    @registration_time        = DateTime.parse task['registrationTime']    
    @estimate_processing_time = task['estimatedProcessingTime'].to_i

    # admin should be notified in this case
    raise OCRSDK::NotEnoughCredits  if @status == :not_enough_credits

    self
  end

  def update
    parse_response api_update_status
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

  def result
    raise OCRSDK::ProcessingFailed  if failed?
    api_get_result
  end

  def wait(seconds=OCRSDK::DEFAULT_POLL_TIME)
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

  def api_get_result
    RestClient.get @result_url.to_s
  rescue RestClient::ExceptionWithResponse
    raise OCRSDK::NetworkError
  end

end
