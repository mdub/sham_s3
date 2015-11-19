require "sinatra/base"

module ShamS3

  class App < Sinatra::Base

    configure do
      disable :verbose
      set :buckets, Hash.new
    end

    before do
      puts "#{request.request_method} #{request.url} #{params.inspect}" if settings.verbose?
    end

    def bucket_name
      params["bucket"]
    end

    def bucket
      settings.buckets[bucket_name]
    end

    head "/:bucket" do
      halt 404 if bucket.nil?
      halt 200
    end

    get "/*" do
      halt 404
    end

    put "/:bucket" do
      settings.buckets[bucket_name] = {}
      halt 200
    end

  end

end
