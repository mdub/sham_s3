require "sinatra/base"

module ShamS3

  class App < Sinatra::Base

    configure do
      disable :verbose
    end

    before do
      puts "#{request.request_method} #{request.url} #{params.inspect}" if settings.verbose?
    end

    head "/*" do
      halt 404
    end

    get "/*" do
      halt 404
    end

    put "/*" do
      halt 404
    end

  end

end
