# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OCRSDK::Verifiers::Language do
  let (:class_with_module) {
    Class.new do
      include OCRSDK::Verifiers::Language
    end
  }
  subject { class_with_module.new }

  it "should have list of languages" do
    OCRSDK::Verifiers::Language::LANGUAGES.length.should > 0
  end

  it "should convert language to string" do
    subject.language_to_s(:meow_meow).should == 'MeowMeow'
  end

  describe ".language_to_sym" do
    it "should convert language to symbol" do
      subject.language_to_sym("MeowMeow").should == :meow_meow
    end

    it "should produce reversible results" do
      subject.language_to_sym(subject.language_to_s(:meow_meow)).should == :meow_meow
    end
  end

  describe ".languages_to_s" do
    it "should convert list of languages to strings" do
      subject.languages_to_s([:hebrew, :serbian_cyrillic]).should == ['Hebrew', 'SerbianCyrillic']
    end

    it "should raise an exception if language doesn't exist" do
      expect {
          subject.languages_to_s([:meow_meow, :pew_pew])
        }.to raise_error(OCRSDK::UnsupportedLanguage)
    end
  end

  describe ".supported_language?" do
    it "should return false for incorrect language" do 
      subject.supported_language?(:meow_meow).should be_false
    end

    it "should return true for correct language as symbol" do
      subject.supported_language?(:russian).should be_true
    end

    it "should return true for correct language as string" do
      subject.supported_language?("Russian").should be_true
    end
  end
end