require 'spec_helper'

require 'aws-sdk-resources'
require 'sham_rack'
require 'sham_s3'

describe ShamS3::App do

  let(:sham_s3_hostname) { "sham-s3.example.com" }

  before do
    ENV["RACK_ENV"] = "test"
    ShamRack.prevent_network_connections
    ShamRack.at(sham_s3_hostname).mount(sham_s3_app)
  end

  after do
    ShamRack.reset
  end

  let(:region) { "ap-southeast-2" }

  let(:aws_config) do
    {}.tap do |config|
      config[:access_key_id] = "key"
      config[:secret_access_key] = "secret"
      config[:region] = region
      config[:endpoint] = "http://#{sham_s3_hostname}"
      config[:force_path_style] = true
      if ENV["SHAM_S3_DEBUG"]
        config[:logger] = Logger.new(STDERR)
        config[:log_level] = :debug
      end
    end
  end

  let(:sham_s3_app) do
    ShamS3::App.new.tap do |app|
      app.settings.verbose = true if ENV["SHAM_S3_DEBUG"]
    end
  end

  let(:s3) { Aws::S3::Resource.new(aws_config) }

  let(:bucket_name) { "foo"}
  let(:bucket) { s3.bucket(bucket_name) }

  describe "bucket" do

    it 'does not exist' do
      expect(bucket).to_not exist
    end

    it "can be created" do
      s3.create_bucket(:bucket => bucket_name)
      expect(bucket).to exist
    end

  end

  describe "object" do

    before do
      s3.create_bucket(:bucket => bucket_name)
    end

    let(:object_name) { "anne_object"}
    let(:object) { bucket.objects(object_name) }

    context "before being written" do

      xit 'does not exist' do
        expect(object).to_not exist
      end

    end

  end

end
