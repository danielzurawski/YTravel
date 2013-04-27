require "rubygems"
require "log4r"
require "json"
require "sinatra"
require "json"
require "./lib/base/ytravel_controller"
require "./lib/controllers/trip_controller"
require "./lib/controllers/landmark_controller"
require "./lib/models/landmark"
require "expedia"
require "google_places"
#require "mongoid"
#require "geocoder"


Expedia.cid = 55505
Expedia.api_key = '5xw4cpaxzfbm23w57x2d486j'
Expedia.shared_secret = 'bUR9HreH'
Expedia.locale = 'en_US'
Expedia.currency_code = 'USD'
Expedia.minor_rev = 13
Mongoid.load!('config/mongoid.yml')

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

logger = Log4r::Logger.new "app"
logger.outputters << Log4r::Outputter.stderr

file = Log4r::FileOutputter.new('app-file', :filename => 'log/ytravel.log')
file.formatter = Log4r::PatternFormatter.new(:pattern => "[%l] %d :: %m")

logger.outputters << file

run Sinatra::Application
# Attach controllers

map '/trip' do
  run YTravel::TripController
end