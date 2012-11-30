# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OCRSDK::Verifiers::Format do
  let (:class_with_module) {
    Class.new do
      include OCRSDK::Verifiers::Format
    end
  }
  subject { class_with_module.new }

  it "should have list of possible input formats" do
    OCRSDK::Verifiers::Format::INPUT_FORMATS.length.should > 0
  end

  it "should have list of possible output formats" do
    OCRSDK::Verifiers::Format::OUTPUT_FORMATS.length.should > 0
  end

  it "should convert format to string" do
    subject.format_to_s(:meow_meow).should == 'meowMeow'
  end

  describe ".supported_input_format?" do
    it "should return false for incorrect input format" do 
      subject.supported_input_format?(:meow_meow).should be_false
    end

    it "should return true for correct input format as symbol" do
      subject.supported_input_format?(:pdf).should be_true
    end

    it "should return true for correct input format as string" do
      subject.supported_input_format?("pdf").should be_true
    end
  end

  describe ".supported_output_format?" do
    it "should return false for incorrect output format" do 
      subject.supported_output_format?(:meow_meow).should be_false
    end

    it "should return true for correct output format as symbol" do
      subject.supported_output_format?(:txt).should be_true
    end

    it "should return true for correct output format as string" do
      subject.supported_output_format?("pdfSearchable").should be_true
    end
  end  
end