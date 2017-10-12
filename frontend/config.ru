require_relative 'public/racker.rb'
require 'bundler'
Bundler.require
use Rack::Static, urls: ["/public"]
run Racker.new
