# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OCRSDK do
  it "should have service url" do 
    OCRSDK::SERVICE_URL.length.should > 0
  end
end