OCRSDK [![Build Status](https://secure.travis-ci.org/andrusha/ocrsdk.png?branch=master)](http://travis-ci.org/andrusha/ocrsdk) [![Dependency Status](https://gemnasium.com/andrusha/ocrsdk.png)](http://gemnasium.com/andrusha/ocrsdk) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/andrusha/ocrsdk)
======

An Abbyy's [OCRSDK](http://ocrsdk.com) API wrapper in Ruby.

Terminology
-----------

Abbyy uses terms "Image" and "Document" in a way that might be confusing at first, so let's get it straight from the beginning:

* Image - is a single input _file_ which result in a single output, it might be _multi-page_ pdf document as well as jpeg image.
* Document - is a collection of files which result in a single output, e.g. a collection of scanned pages in tiff format.

Installation
------------

```bash
gem install ocrsdk
```

Configuration
-------------

```ruby
OCRSDK.setup do |config|
  config.application_id = '99bottlesofbeer'
  config.password = '98bottlesofbeer'
end
```

Usage
-----

There are two basic workflows - synchornous and asynchronous. The first one is simpler, but since recognition may take a significant amount of time and you may want to utilize the same thread (or give response to the user, that processing is started) while document is processed there is also an asynchronous version of each function.

### Simple

```ruby
image = OCRSDK::Image.new '~/why_cats_paint.pdf'

# sync
image.as_text_sync([:english]) # => "because they can"
image.as_pdf_sync([:english], '~/why_cats_paint_ocred.pdf') # # => 31337 (bytes written)

# async
promise = image.as_text([:english])
puts "Your document would be ready in #{promise.estimate_completion}"
promise.wait.result # byte-string, you might need to .force_encoding("utf-8") => "because they can"
```

### Advanced

```ruby
# have the same methods as Image + a few format-specific
pdf = OCRSDK::PDF.new '~/why_cats_paint.pdf'
unless pdf.recognizeable?
  return puts "Your document is already recognized"
end

promise = pdf.as_pdf([:english]) # pdf with images as pdf recognized
puts "Your document would be ready in #{promise.estimate_completion}"

while promise.processing?
  begin
    promise.update
    sleep 5
  rescue OCRSDK::NotEnoughCredits
    return puts "You need to purchase more credits for your account"
  end
end

if promise.completed?
  File.open('~/why_cats_paint_ocred.pdf', 'wb+') {|f| f.write promise.result }
else
  puts "Processing failed"
end
```

Copyright
=========
Copytright © 2012 Andrey Korzhuev. See LICENSE for details.
