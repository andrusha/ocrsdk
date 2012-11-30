class OCRSDK::AbstractEntity
  def initialize(application_id=nil, password=nil)
    @application_id = application_id || '' # Rails.configuration.ocrsdk.application_id
    @password       = password       || '' # Rails.configuration.ocrsdk.password

    @url = prepare_url @application_id, @password
  end

private

  def prepare_url(app_id, pass)
    URI("http://#{CGI.escape app_id}:#{CGI.escape pass}@#{OCRSDK::SERVICE_URL}")
  end
end
