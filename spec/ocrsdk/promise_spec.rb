# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OCRSDK::Promise do
  before do
    OCRSDK.setup do |config|
      config.application_id = 'app_id'
      config.password = 'pass'
    end
  end

  describe ".parse_response" do
    context "correct response" do
      subject { OCRSDK::Promise.new(nil).parse_response OCRSDK::Mock.response(:get_task_status, :submitted) }

      its(:task_id)    { should == '22345200-abe8-4f60-90c8-0d43c5f6c0f6' }
      its(:status)     { should == :submitted }
      its(:result_urls) { should == ['http://cloud.ocrsdk.com/result_url',nil,nil] }
      its(:estimate_processing_time) { should == 3600 }
      its(:estimate_completion) { should == DateTime.parse("2001-01-01T13:18:22Z") + 3600.seconds }      
    end

    context "incorrect response" do
      subject { OCRSDK::Promise.new nil }

      it "should raise OCRSDKError" do
        expect {
          subject.parse_response ''
        }.to raise_error(OCRSDK::OCRSDKError)
      end
    end

    context "insufficient credits" do
      subject { OCRSDK::Promise.new nil }

      it "should raise an OCRSDK::NotEnoughCredits error" do
        expect {
          subject.parse_response OCRSDK::Mock.response(:get_task_status, :not_enough_credits)
        }.to raise_error(OCRSDK::NotEnoughCredits)
      end
    end
  end 

  describe "self.from_response" do
    subject { OCRSDK::Promise.from_response OCRSDK::Mock.response(:get_task_status, :submitted) }

    its(:task_id)    { should == '22345200-abe8-4f60-90c8-0d43c5f6c0f6' }
    its(:status)     { should == :submitted }
    its(:result_urls) { should == ['http://cloud.ocrsdk.com/result_url',nil,nil] }
    its(:estimate_processing_time) { should == 3600 }
    its(:estimate_completion) { should == DateTime.parse("2001-01-01T13:18:22Z") + 3600.seconds }
  end

  describe ".update" do
    subject { OCRSDK::Promise.new 'update-task-id' }
    before do
      OCRSDK::Mock.in_progress
      subject.update
    end

    its(:task_id) { should == 'update-task-id' }
    its(:status)  { should == :in_progress }

    it "should raise a NetworkError in case REST request fails, and retry 3 times" do
      RestClient.stub(:get) {|url| raise RestClient::ExceptionWithResponse }
      RestClient.should_receive(:get).exactly(3)

      expect {
        subject.result(0)
      }.to raise_error(OCRSDK::NetworkError)
    end
  end

  describe ".api_update_status" do
    subject { OCRSDK::Promise.new 'test' }

    it "should make an api call with correct url" do
      RestClient.stub(:get) do |url| 
        url.to_s.should == "http://app_id:pass@cloud.ocrsdk.com/getTaskStatus?taskId=test"
      end
      RestClient.should_receive(:get).once
      subject.instance_eval { api_update_status }
    end

    it "should raise a NetworkError in case REST request fails" do
      RestClient.stub(:get) {|url| raise RestClient::ExceptionWithResponse }
      RestClient.should_receive(:get).once

      expect {
        subject.instance_eval { api_update_status }
      }.to raise_error(OCRSDK::NetworkError)
    end
  end

  describe ".result" do
    context "processing completed without errors" do
      before { OCRSDK::Mock.success }
      subject { OCRSDK::Promise.from_response OCRSDK::Mock.response(:get_task_status, :completed) }

      its(:result) { should == 'meow' }
      its(:result2) { should == 'meow2' }
      its(:result3) { should == 'meow3' }

      it "should raise NetworkError in case getting file fails, but retry 3 times before failing" do
        RestClient.stub(:get) {|url| raise RestClient::ExceptionWithResponse }
        RestClient.should_receive(:get).exactly(3)

        expect {
          subject.result(0)
        }.to raise_error(OCRSDK::NetworkError)        
      end
    end

    context "processing failed" do
      subject { OCRSDK::Promise.from_response OCRSDK::Mock.response(:get_task_status, :failed) }

      it "should raise an ProcessingFailed" do
        expect {
          subject.result
        }.to raise_error(OCRSDK::ProcessingFailed)
      end
    end
  end

  describe ".completed? and .failed?" do
    context "processed job" do
      subject { OCRSDK::Promise.from_response OCRSDK::Mock.response(:get_task_status, :in_progress) }

      its(:processing?) { should be_true }
      its(:completed?)  { should be_false }
      its(:failed?)     { should be_false }
    end

    context "completed job" do
      subject { OCRSDK::Promise.from_response OCRSDK::Mock.response(:get_task_status, :completed) }

      its(:processing?) { should be_false }
      its(:completed?)  { should be_true }
      its(:failed?)     { should be_false }
    end

    context "failed job" do
      subject { OCRSDK::Promise.from_response OCRSDK::Mock.response(:get_task_status, :failed) }

      its(:processing?) { should be_false }
      its(:completed?)  { should be_false }
      its(:failed?)     { should be_true }
    end
  end

  describe ".wait" do
    subject { OCRSDK::Promise.from_response OCRSDK::Mock.response(:get_task_status, :in_progress) }

    it "should check the status as many times as needed waiting while ocr is completed" do
      called_once = false
      subject.stub(:update) do
        if called_once
          subject.parse_response OCRSDK::Mock.response(:get_task_status, :completed)
        else
          called_once = true
        end
      end
      subject.should_receive(:update).twice

      start = Time.now
      subject.wait 0.1
      (Time.now - start).should >= 0.2
    end
  end

end
