class OCRSDK::AbstractEntity
  def initialize
    @url = prepare_url OCRSDK.config.application_id, OCRSDK.config.password
  end

private

  def prepare_url(app_id, pass)
    URI("http://#{CGI.escape app_id}:#{CGI.escape pass}@#{OCRSDK::SERVICE_URL}")
  end
end
