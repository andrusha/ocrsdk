module OCRSDK::Verifiers::Format
  # http://ocrsdk.com/documentation/specifications/image-formats/
  INPUT_FORMATS = [:bmp, :dcx, :pcx, :png, :jp2, :jpc, :jpg, :jpeg, :jfif, :pdf, 
    :tif, :tiff, :gif, :djvu, :djv, :jb2].freeze

  # http://ocrsdk.com/documentation/apireference/processImage/
  OUTPUT_FORMATS = [:txt, :rtf, :docx, :xlsx, :pptx, :pdf_searchable, 
    :pdf_text_and_images, :xml, :alto].freeze

  def format_to_s(format)
    Array(format).map do |f|
      f.to_s.camelize(:lower)
    end.join(",")
  end

  def supported_input_format?(format)
    format = format.downcase.to_sym  if format.kind_of? String

    INPUT_FORMATS.include? format
  end

  def supported_output_format?(format)
    formats = Array(format).map do |f|
      f.kind_of?(String) ? f.underscore.to_sym : f
    end

    formats.all? {|format| OUTPUT_FORMATS.include? format }
  end

end
