#!/usr/bin/env ruby
require 'gli'
begin # XXX: Remove this begin/rescue before distributing your app
require 'gbot'
require 'require_all'
require 'mongoid'

rescue LoadError
  STDERR.puts "In development, you need to use `bundle exec bin/gbot` to run your app"
  STDERR.puts "At install-time, RubyGems will make sure lib, etc. are in the load path"
  STDERR.puts "Feel free to remove this message from bin/gbot now"
  exit 64
end

# Dir[File.expand_path("config/*.rb", File.dirname(__FILE__))].map {|f| puts require f}
# Dir[File.expand_path("lib/exchanges/*.rb", File.dirname(__FILE__))].map {|f| require f}
# Dir[File.expand_path("models/*.rb", File.dirname(__FILE__))].map {|f| require f}
# Dir["/models/*.rb"].each {|file| require file }

require_all 'models'
require_all 'lib'
require_all 'config'

ENV["RACK_ENV"] = "development"
puts "HERES THE ENV"
puts ENV['RAKE_ENV']

Mongoid.load!("config/mongoid.yml")
# Mongoid.logger.level = Logger::DEBUG
# Mongo::Logger.logger.level = Logger::DEBUG


# require './lib/exchanges/binance'
include GLI::App

program_desc 'Describe your application here'

version Gbot::VERSION

subcommand_option_handling :normal
arguments :strict

desc 'Describe some switch here'
switch [:s,:switch]

desc 'Describe some flag here'
default_value 'the default'
arg_name 'The name of the argument'
flag [:f,:flagname]

desc 'Describe trade here'
arg_name 'Describe arguments to trade here'
command :trade do |c|
  c.desc 'Describe a switch to trade'
  c.switch :s

  c.desc 'Describe a flag to trade'
  c.default_value 'default'
  c.flag :f
  c.action do |global_options,options,args|

    # Your command logic here
     puts options["f"]
    # If you have any errors, just raise them
    # raise "that command made no sense"

    puts "trade command ran"
  end
end

desc 'put period value'
arg_name 'Describe arguments to sim here'
command :sim do |c|
  c.action do |global_options,options,args|
    puts args[0]
    puts "sim command ran"
   # Binance.getTrades("BTC-LTC")
   # Binance.saveTrades()
     Binance.simTrading("binance.LTCBTC", 20)
  end
end


desc 'Describe backfill here'
arg_name 'Describe arguments to backfill here'
command :backfill do |c|
  c.action do |global_options,options,args|
    puts "backfill command ran"
    puts args[0] 
    puts args[1]
    Binance.backFill("BTC-LTC", args[1])

  end
end

pre do |global,command,options,args|
  # Pre logic here
  # Return true to proceed; false to abort and not call the
  # chosen command
  # Use skips_pre before a command to skip this block
  # on that command only
  true
end

post do |global,command,options,args|
  # Post logic here
  # Use skips_post before a command to skip this
  # block on that command only
end

on_error do |exception|
  # Error logic here
  # return false to skip default error handling
  true
end

exit run(ARGV)
