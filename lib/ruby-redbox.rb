require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

class RedboxAPI
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
      headers = {"Host" => "www.redbox.com", "Accept" => "application/json, text/javascript, */*", "X-Requested-With" => "XMLHttpRequest", "User-Agent" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13", "Cookie" => "ASP.NET_SessionId=przaowkuetjyjsezsu3cqooe; rbuser=Validation=exXiQC/PjMAZY2Z3jWqNpaaSrje+peGrA5EcJ7rvuY4=; LB=2021814026.0.0000; RB_2.1=1; s_cc=true; c_m=undefinedDirect%20LoadDirect%20Load; s_sq=%5B%5BB%5D%5D; s_vi=[CS]v1|26CB2B70851D3189-60000128600DAA0B[CE]; _json=%7B%22locationSearchValue%22%3A%22%5C%2221209%5C%22%22%7D", "__K" => "zI9Y1ZyWISIwgrAhIfSZElRqonnXBG12UqNNl1HCRFA="}
      url = URI.parse("http://www.redbox.com/api/Store/GetStores/")
      request = Net::HTTP::Post.new(url.path)
      request.body = body
      headers.each do |key, value|
        request[key] = value
      end
      response = Net::HTTP.new(url.host, url.port).start {|http| http.request(request) }
      NearestKiosks.new(JSON.parse(response.body))
    end
  end
  
  class Data
    attr_reader :data
    
    def initialize(data)
      @data = data
    end
    
    def method_missing(method)
      key = data[method.to_s]
      key && key['data']
    end
    
    def inspect
      data = @data.inject([]) { |collection, key| collection << "#{key[0]}: #{key[1]['data']}"; collection }.join("\n    ")
      "#<#{self.class}:0x#{object_id}\n    #{data}>"
    end
  end
  
  class NearestKiosks < Data; end
end