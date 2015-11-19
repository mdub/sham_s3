require 'spec_helper'

require 'aws-sdk-resources'
require 'sham_rack'
require 'sham_s3'

describe ShamS3::App do

  let(:sham_s3_app) { ShamS3::App.new }

  before do
    ENV["RACK_ENV"] = "test"
    ShamRack.allow_network_connections = false
    ShamRack.at("s3.amazonaws.com").mount(sham_s3_app)
    ShamRack.at("foo.s3-ap-southeast-2.amazonaws.com", 443).mount(sham_s3_app)
  end

  after do
    ShamRack.unmount_all
    ShamRack.allow_network_connections = true
  end

  let(:region) { "ap-southeast-2" }

  let(:aws_config) do
    {}.tap do |config|
      config[:access_key_id] = "key"
      config[:secret_access_key] = "secret"
      config[:region] = region
      if ENV["AWS_SDK_DEBUG"]
        config[:logger] = Logger.new(STDERR)
        config[:log_level] = :debug
      end
    end
  end

  let(:s3) { Aws::S3::Resource.new(aws_config) }

  describe "bucket" do

    let(:bucket_name) { "foo"}
    let(:bucket) { s3.bucket(bucket_name) }

    before do
      ShamRack.at("#{bucket_name}.s3-#{region}.amazonaws.com", 443).mount(sham_s3_app)
    end

    it 'does not exist' do
      expect(bucket).to_not exist
    end

    xit "can be created" do
      s3.create_bucket(:bucket => bucket_name)
      expect(bucket).to exist
    end

  end

end
