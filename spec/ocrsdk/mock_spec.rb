# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OCRSDK::Mock do

  describe ".response" do
    it "should read response from file" do
      OCRSDK::Mock.response(:test, :test).should == 'meow'
    end

    it "should raise an exception if response is not found" do
      expect {
        OCRSDK::Mock.response(:test, :non_existant_file)
      }.to raise_error(Errno::ENOENT)
    end
  end

end
