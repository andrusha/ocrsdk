class OCRSDK::PDF < OCRSDK::Image
  # We're on a shaky ground regarding what kind of pdfs
  # should be recognized and what shouldn't.
  # Currently we count that if there are
  #   images * 20 > length of text
  # then this document might need recognition.
  # Assumption is that there might be a title,
  # page numbers or credits along with images.
  def recognizeable?
    reader = PDF::Reader.new @image_path

    images = 0
    text   = 0
    chars  = Set.new
    reader.pages.each do |page|
      text   += page.text.length
      chars  += page.text.split('').map(&:ord).uniq
      images += page.xobjects.map {|k, v| v.hash[:Subtype]}.count(:Image)
    end

    # count number of distinct characters
    # in case of "searchable", but incorrectly recognized document
    images * 20 > text || chars.length < 10
  rescue PDF::Reader::MalformedPDFError, PDF::Reader::UnsupportedFeatureError
    false
  end
end
