require 'rubygems'
gem 'httparty'
require 'httparty'

class RedboxAPI
  include HTTParty
  base_uri "www.redbox.com"
  
  class << self
  
    def get_titles
      url = URI.parse('http://www.redbox.com/api/product/js/titles')
      response = Net::HTTP.start(url.host, url.port){|http| http.get(url.path)}
      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        @titles = response.body[13..-1]
      else
        response.error
      end
    end  
  end
end
