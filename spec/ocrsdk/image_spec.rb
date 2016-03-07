# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OCRSDK::Image do
  before do
    OCRSDK.setup do |config|
      config.application_id = 'app_id'
      config.password = 'pass'
      config.retry_wait_time = 0
    end
    OCRSDK::Mock.success
  end

  subject { OCRSDK::Image.new TestFiles.russian_jpg_path }

  describe ".as_languages_and_formats" do
    it "should call api and return Promise" do
      subject.as_languages_and_formats([:russian],[:txt, :xml], :text_extraction).should be_kind_of(OCRSDK::Promise)
    end
  end

  describe ".as_text" do
    it "should call api and return Promise" do
      subject.as_text([:russian]).should be_kind_of(OCRSDK::Promise)
    end
  end

  describe ".as_text_sync" do
    it "should wait till Promise is done and return result" do
      subject.as_text_sync([:russian], 0).should == 'meow'
    end
  end

  describe ".as_xml" do
    it "should call api and return Promise" do
      subject.as_xml([:russian]).should be_kind_of(OCRSDK::Promise)
    end

    it "should pass :barcode_recognition profile and return Promise" do
      subject.as_xml([:russian], :barcode_recognition).should be_kind_of(OCRSDK::Promise)
    end
  end

  describe ".as_xml_sync" do
    it "should wait till Promise is done and return result" do
      subject.as_xml_sync([:russian], 0).should == 'meow'
    end
  end

  describe ".as_pdf" do
    it "should call api and return Promise" do
      subject.as_pdf([:russian]).should be_kind_of(OCRSDK::Promise)
    end
  end

  describe ".as_pdf_sync" do
    it "should wait till Promise is done and return result if output file isn't specified" do
      subject.as_pdf_sync([:russian], nil, 0).should == 'meow'
    end

    it "should wait till Promise is done and write result in file" do
      outpath = File.join(File.dirname(File.expand_path(__FILE__)), 'output.pdf')
      subject.as_pdf_sync([:russian], outpath, 0)
      File.exists?(outpath).should be_true
      File.delete outpath
    end
  end

  describe ".api_process_image" do
    it "should raise UnsupportedLanguage on unsupported language" do
      expect {
        subject.instance_eval { api_process_image TestFiles.russian_jpg_path, [:meow] }
      }.to raise_error(OCRSDK::UnsupportedLanguage)
    end

    it "should raise UnsupportedInputFormat on unsupported input format" do
      expect {
        subject.instance_eval { api_process_image 'image.meow', [:russian] }
      }.to raise_error(OCRSDK::UnsupportedInputFormat)
    end

    it "should raise UnsupportedOutputFormat on unsupported output format" do
      expect {
        subject.instance_eval { api_process_image TestFiles.russian_jpg_path, [:russian], :meow }
      }.to raise_error(OCRSDK::UnsupportedOutputFormat)
    end

    it "should raise UnsupportedProfile on unsupported profile" do
      expect {
        subject.instance_eval { api_process_image TestFiles.russian_jpg_path, [:russian], :txt, :meow }
      }.to raise_error(OCRSDK::UnsupportedProfile)
    end

    it "should raise NetworkError on problems with REST request, retry 3 times before failing" do
      RestClient.stub(:post) {|url, params| raise RestClient::ExceptionWithResponse }
      RestClient.should_receive(:post).exactly(3)

      expect {
        subject.instance_eval { api_process_image TestFiles.russian_jpg_path, [:russian] }
      }.to raise_error(OCRSDK::NetworkError)
    end

    it "should do a post request with correct url and file attached" do
      RestClient.stub(:post) do |uri, params|
        uri.to_s.should == "http://app_id:pass@cloud.ocrsdk.com/processImage?language=Russian%2CEnglish&exportFormat=txt&profile=documentConversion"
        params[:upload][:file].should be_kind_of(File)
      end
      RestClient.should_receive(:post).once
      subject.instance_eval { api_process_image TestFiles.russian_jpg_path, [:russian, :english], :txt, :document_conversion }
    end
  end
end
