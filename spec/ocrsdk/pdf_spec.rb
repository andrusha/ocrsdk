# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OCRSDK::PDF do
  before do
    OCRSDK.setup do |config|
      config.application_id = 'meow'
      config.password = 'purr'
    end    
  end
  
  describe ".recognizeable?" do
    it "should return false for a document with text only" do
      OCRSDK::PDF.new(TestFiles.lorem_pdf).recognizeable?.should be_false
    end

    it "should return false for document with a lot of text and some images" do
      OCRSDK::PDF.new(TestFiles.lorem_complex_pdf).recognizeable?.should be_false
    end

    it "should return true for document with images only" do
      OCRSDK::PDF.new(TestFiles.recognizeable_pdf).recognizeable?.should be_true
    end

    it "should return false for malformed document" do
      OCRSDK::PDF.new(TestFiles.malformed_pdf).recognizeable?.should be_false
    end

    it "should return true for 'searchable' document with malformed text underneath the pic" do
      OCRSDK::PDF.new(TestFiles.searchable_malformed_pdf).recognizeable?.should be_true
    end

    it "should return true for recognizeable document with title page" do
      OCRSDK::PDF.new(TestFiles.recognizeable_title_pdf).recognizeable?.should be_true
      OCRSDK::PDF.new(TestFiles.recognizeable_title2_pdf).recognizeable?.should be_true
    end
  end
end
