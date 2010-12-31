require 'rubygems'
gem 'httparty'
require 'httparty'

class Redbox
  include HTTParty
  base_uri "www.redbox.com"
  
  def initialize
  end
  
  def get_titles
    response = self.class.get("/api/product/js/titles")[13..-1]    
    @titles || = response
  end  
end
