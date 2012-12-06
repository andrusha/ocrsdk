module OCRSDK::Verifiers::Profile
  # http://ocrsdk.com/documentation/specifications/processing-profiles/
  PROFILES = [:document_conversion, :document_archiving, :text_extraction,
    :field_level_recognition, :barcode_recognition].freeze

  def profile_to_s(profile)
    profile.to_s.camelize(:lower)
  end

  def supported_profile?(profile)
    profile = profile.underscore.to_sym  if profile.kind_of? String

    PROFILES.include? profile
  end
end
