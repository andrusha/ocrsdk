# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OCRSDK::Verifiers::Profile do
  let (:class_with_module) {
    Class.new do
      include OCRSDK::Verifiers::Profile
    end
  }
  subject { class_with_module.new }

  it "should have list of possible profiles" do
    OCRSDK::Verifiers::Profile::PROFILES.length.should > 0
  end

  it "should convert profile to string" do
    subject.profile_to_s(:meow_meow).should == 'meowMeow'
  end

  describe ".supported_profile?" do
    it "should return false for incorrect profile" do 
      subject.supported_profile?(:meow_meow).should be_false
    end

    it "should return true for correct profile as symbol" do
      subject.supported_profile?(:document_conversion).should be_true
    end

    it "should return true for correct profile as string" do
      subject.supported_profile?("documentConversion").should be_true
    end
  end
end