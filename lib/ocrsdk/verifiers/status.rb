module OCRSDK::Verifiers::Status
  # http://ocrsdk.com/documentation/specifications/task-statuses/
  STATUSES = [:submitted, :queued, :in_progress, :completed, 
    :processing_failed, :deleted, :not_enough_credits]

  def status_to_s(status)
    status.to_s.camelize
  end

  def status_to_sym(status)
    status.underscore.to_sym
  end

  def supported_status?(status)
    status = status_to_sym status  if status.kind_of? String

    STATUSES.include? status
  end
end
