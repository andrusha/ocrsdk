# As a separate module, because we might want to
# mock some files in the future or use generator
# for the same reason it returns opened instance of file
#
# Each method check if corresponding file exists in
# spec/support/files/file.name.kitten.ext
# if method has `_path` in the end Pathname instance would be returned
# otherwise it will be File instance
module TestFiles
  def self.respond_to?(method)
    File.exists? self.filename(method)
  end

  def self.method_missing(method, *args, &block)
    fname = self.filename(method)
    if File.exists? fname
      if only_path? method
        fname
      else
        File.open(fname)
      end
    else
      super
    end
  end

  def self.filename(method)
    method = method[0..-6]  if only_path? method
    File.join(File.dirname(File.expand_path(__FILE__)), '..', 'fixtures', 'files', method.to_s.gsub('_', '.'))
  end

  def self.only_path?(method)
    method[-5..-1] == '_path'
  end

end
