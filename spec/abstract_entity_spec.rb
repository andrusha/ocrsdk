# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OCRSDK::AbstractEntity do
  before do
    OCRSDK.setup do |config|
      config.application_id = 'meow'
      config.password = 'purr'
    end
  end

  it "should initialize and prepare url" do
    OCRSDK::AbstractEntity.new.instance_eval { @url }.to_s.should_not be_empty
  end

  it "should prepare url correctly" do
    OCRSDK::AbstractEntity.new.instance_eval { prepare_url 'meow!', "'pew'" }.to_s.should == "http://meow%21:%27pew%27@cloud.ocrsdk.com"
  end
end
