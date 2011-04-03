require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

class Redbox
  class << self
  
    def get_titles
      url = URI.parse('http://www.redbox.com/api/product/js/titles')
      response = Net::HTTP.start(url.host, url.port){|http| http.get(url.path)}
      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        @titles = response.body[13..-1]
      else
        response.message
      end
    end
    
    def find_nearest_kiosks(title_id, lat, lon)
      body = "{\"filters\":{\"proximity\":{\"lat\":#{lat},\"lng\":#{lon},\"radius\":50}},\"resultOptions\":{\"max\":50,\"profile\":true,\"status\":true,\"proximity\":true,\"user\":true,\"inventory\":true,\"inventoryProducts\":[\"#{title_id}\"]}}"
      headers = {"Host" => "www.redbox.com", "Accept" => "application/json, text/javascript, */*", "X-Requested-With" => "XMLHttpRequest", "User-Agent" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13", "Cookie" => "rbuser=Validation=exXiQC/PjMAZY2Z3jWqNpaaSrje+peGrA5EcJ7rvuY4=; RB_2.1=1;", "__K" => "zI9Y1ZyWISIwgrAhIfSZElRqonnXBG12UqNNl1HCRFA="}
      url = URI.parse("http://www.redbox.com/api/Store/GetStores/")
      request = Net::HTTP::Post.new(url.path)
      request.body = body
      headers.each do |key, value|
        request[key] = value
      end
      response = Net::HTTP.new(url.host, url.port).start {|http| http.request(request) }
      parsed_response = JSON.parse(response.body)
      if parsed_response["d"]["success"] == false
        return parsed_response["d"]["msg"]
      else
        kiosks = []
        parsed_response["d"]["data"].each do |kiosk|
          kiosks << Kiosk.new(kiosk)
        end
        return kiosks
      end
    end
  end
  
  class Kiosk
    attr_accessor :vendor, :distance, :indoor, :address, :city, :state, :zip
    
    def initialize(options = {})
      @vendor = options["profile"]["vendor"]
      @distance = options["proximity"]["dist"]
      @indoor = options["profile"]["indoor"]
      @address = options["profile"]["addr"]
      @city = options["profile"]["city"]
      @state = options["profile"]["state"]
      @zip = options["profile"]["zip"]
    end
  end
end