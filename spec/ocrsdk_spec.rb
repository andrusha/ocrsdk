# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OCRSDK do
  it "should have service url" do 
    OCRSDK::SERVICE_URL.length.should > 0
  end

  it "should be configurable" do
    OCRSDK.setup do |config|
      config.application_id = 'meow'
      config.password = 'purr'
    end

    OCRSDK.config.application_id.should == 'meow'
    OCRSDK.config.password.should == 'purr'
  end
end