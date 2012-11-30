# Intended to be included into target classes
# they serve the purpose of validating and converting
# symbols between internal and outside api representations
module OCRSDK::Verifiers
end

Dir[File.dirname(__FILE__) + '/verifiers/*.rb'].each do |file| 
  require file
end
