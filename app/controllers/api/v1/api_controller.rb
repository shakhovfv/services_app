require 'httparty'
require 'nokogiri'

module Api::V1
  class ApiController < ApplicationController
    include HTTParty
    include Nokogiri

  end
end
