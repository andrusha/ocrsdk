# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OCRSDK::Verifiers::Status do
  let (:class_with_module) {
    Class.new do
      include OCRSDK::Verifiers::Status
    end
  }
  subject { class_with_module.new }

  it "should have list of statuses" do
    OCRSDK::Verifiers::Status::STATUSES.length.should > 0
  end

  it "should convert status to string" do
    subject.status_to_s(:meow_meow).should == 'MeowMeow'
  end

  describe ".status_to_sym" do
    it "should convert status to symbol" do
      subject.status_to_sym("MeowMeow").should == :meow_meow
    end

    it "should produce reversible results" do
      subject.status_to_sym(subject.status_to_s(:meow_meow)).should == :meow_meow
    end
  end

  describe ".supported_status?" do
    it "should return false for incorrect language" do 
      subject.supported_status?(:meow_meow).should be_false
    end

    it "should return true for correct status as symbol" do
      subject.supported_status?(:submitted).should be_true
    end

    it "should return true for correct status as string" do
      subject.supported_status?("Submitted").should be_true
    end
  end
end