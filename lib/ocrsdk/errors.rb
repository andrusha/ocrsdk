module OCRSDK
  class OCRSDKError         < RuntimeError; end
  
  class NetworkError        < OCRSDKError; end
  class NotEnoughCredits    < OCRSDKError; end
  class ProcessingFailed    < OCRSDKError; end

  class UnsupportedFeature  < OCRSDKError; end
  class UnsupportedLanguage < UnsupportedFeature; end
  class UnsupportedProfile  < UnsupportedFeature; end
  class UnsupportedInputFormat  < UnsupportedFeature; end
  class UnsupportedOutputFormat < UnsupportedFeature; end
end