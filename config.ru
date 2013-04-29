require "rubygems"
require "log4r"
require "json"
require 'sinatra'
require "json"
require "./lib/base/ytravel_controller"
require "./lib/module/trip/models/landmark"
require "./lib/module/trip/models/google_api"
require "./lib/module/trip/models/yahoo_api"
require "./lib/module/trip/controllers/trip_controller"
require "./lib/module/trip/controllers/landmark_controller"
require "expedia"
require "google_places"
require 'rack/cors'
require 'google/api_client'
require 'net/http'
require "googleajax"
require 'yql'
require "rack/timeout"

use Rack::Timeout           # Call as early as possible so rack-timeout runs before other middleware.
Rack::Timeout.timeout = 120  # This line is optional. If omitted, timeout defaults to 15 seconds.

# First, setup referrer:
GoogleAjax.referrer = "your_domain_name_here"

# Optionally, you can set an api_key:
GoogleAjax.api_key = "AIzaSyBfQ0RtDqywSlAauWtPvNH_cwYpJdiN_T0"


Expedia.cid = 55505
Expedia.api_key = '5xw4cpaxzfbm23w57x2d486j'
Expedia.shared_secret = 'bUR9HreH'
Expedia.locale = 'en_US'
Expedia.currency_code = 'USD'
Expedia.minor_rev = 13
#Mongoid.load!('config/mongoid.yml')

#APP_ROOT = File.dirname(__FILE__)
#puts APP_ROOT
#Dir.glob("#{APP_ROOT}/lib/base/*.rb").each { |lib| 
#	require File.basename(lib, '.*') 
#}

#Dir.glob("#{APP_ROOT}/lib/controllers/*.rb").each { |lib| 
#	require File.basename(lib, '.*') 
#}

#Dir.glob("#{APP_ROOT}/lib/models/*.rb").each { |lib| 
# 	require File.basename(lib, '.*') 
#}

#logger = Log4r::Logger.new "app"
#logger.outputters << Log4r::Outputter.stderr

#file = Log4r::FileOutputter.new('app-file', :filename => 'log/ytravel.log')
#file.formatter = Log4r::PatternFormatter.new(:pattern => "[%l] %d :: %m")

#logger.outputters << file
root = ::File.dirname(__FILE__)

use Rack::Cors do
	allow do
    	origins 'http://ytravel.herokuapp.com/' ,'localhost:3000', '127.0.0.1:3000',
             	/http:\/\/192\.168\.0\.\d{1,3}(:\d+)?/
             	# regular expressions can be used here

     	resource '/file/list_all/', :headers => 'x-domain-token'
     	resource '/file/at/*',
         	:methods => [:get, :post, :put, :delete, :options],
         	:headers => 'x-domain-token',
         	:expose => ['Some-Custom-Response-Header']
         	# headers to expose
   	end

    allow do
		origins '*', 'http://ytravel.herokuapp.com/', 'http://localhost:9292/'
    	resource '*', :headers => :any, :methods => [:get, :post]
	end
end

run Sinatra::Application
# Attach controllers

map '/trip' do
  run YTravel::TripController
end

use Rack::Static, 
  :urls => ["/images", "/js", "/css"],
  :root => "public"

run lambda { |env|
  [
    200, 
    {
      'Content-Type'  => 'text/html', 
      'Cache-Control' => 'public, max-age=86400' 
    },
    File.open('public/index.html', File::RDONLY)
  ]
}