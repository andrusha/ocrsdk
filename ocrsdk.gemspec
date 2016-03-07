Gem::Specification.new do |s|
  s.name = "ocrsdk"
  s.version = File.read("VERSION").delete("\n\r")
  s.authors = ["Andrew Korzhuev"]
  s.description = %q{Abbyy's OCR (ocrsdk.com) API wrapper in Ruby.}
  s.summary = %q{Abbyy's OCR (ocrsdk.com) API wrapper in Ruby.}
  s.email = "andrew@korzhuev.com"
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.homepage = "http://github.com/andrusha/ocrsdk"
  s.require_paths = ["lib"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.add_runtime_dependency "rest-client" #git://github.com/babatakao/rest-client.git
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "pdf-reader"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "retryable", "~> 1.3"

  s.add_development_dependency "rake", ">= 0.8"
  s.add_development_dependency "rspec", "~> 2"
  s.add_development_dependency "webmock"
end
