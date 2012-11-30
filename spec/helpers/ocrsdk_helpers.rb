module OCRSDKHelpers

  def process_image_response
    <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <response>
        <task id="22345200-abe8-4f60-90c8-0d43c5f6c0f6"
          registrationTime="2001-01-01T13:18:22Z"
          statusChangeTime="2001-01-01T13:18:22Z"
          status="Submitted"
          error="{An error message.}"
          filesCount="10"
          credits="10"
          estimatedProcessingTime="3600"
          resultUrl="http://domain/blob ID"
          description="My first OCR task"/>
        <task/>
      </response>
    XML
  end

  def process_image_response_credits
    <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <response>
        <task id="22345200-abe8-4f60-90c8-0d43c5f6c0f6"
          registrationTime="2001-01-01T13:18:22Z"
          statusChangeTime="2001-01-01T13:18:22Z"
          status="NotEnoughCredits"
          error="{An error message.}"
          filesCount="10"
          credits="0"
          estimatedProcessingTime="3600"
          resultUrl="http://domain/blob ID"
          description="My first OCR task"/>
        <task/>
      </response>
    XML
  end

  def process_image_updated_response
    <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <response>
        <task id="update-task-id"
          registrationTime="2001-01-01T13:18:22Z"
          statusChangeTime="2001-02-01T13:18:22Z"
          status="InProgress"
          error="{An error message.}"
          filesCount="10"
          credits="10"
          estimatedProcessingTime="3600"
          resultUrl="http://domain/blob ID"
          description="My first OCR task"/>
        <task/>
      </response>
    XML
  end

  def process_image_completed_response
    <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <response>
        <task id="update-task-id"
          registrationTime="2001-01-01T13:18:22Z"
          statusChangeTime="2001-03-01T13:18:22Z"
          status="Completed"
          error="{An error message.}"
          filesCount="10"
          credits="10"
          estimatedProcessingTime="3600"
          resultUrl="http://domain/blob ID"
          description="My first OCR task"/>
        <task/>
      </response>
    XML
  end

  def process_image_failed_response
    <<-XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <response>
        <task id="update-task-id"
          registrationTime="2001-01-01T13:18:22Z"
          statusChangeTime="2001-03-01T13:18:22Z"
          status="ProcessingFailed"
          error="{An error message.}"
          filesCount="10"
          credits="10"
          estimatedProcessingTime="3600"
          resultUrl="http://domain/blob ID"
          description="My first OCR task"/>
        <task/>
      </response>
    XML
  end

  def mock_ocrsdk
    OCRSDK::Image.any_instance.stub(:api_process_image) { |x,y,i,j| process_image_response }
    OCRSDK::Promise.any_instance.stub(:api_update_status) { process_image_completed_response }
    OCRSDK::Promise.any_instance.stub(:api_get_result) { "meow" }    
  end

end

RSpec.configuration.include OCRSDKHelpers
