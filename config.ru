require "rubygems"
require "./app"
require "log4r"

logger = Log4r::Logger.new "app"
logger.outputters << Log4r::Outputter.stderr

file = Log4r::FileOutputter.new('app-file', :filename => 'log/app.log')
file.formatter = Log4r::PatternFormatter.new(:pattern => "[%l] %d :: %m")

logger.outputters << file

run App
