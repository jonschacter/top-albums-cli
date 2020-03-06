require 'bundler'
Bundler.require

require 'pry'
require 'nokogiri'
require 'open-uri'
require 'rest-client'
require 'json'

module Concerns
end

require_all 'lib/concerns'
require_all 'lib'