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
    
    def find_nearest_kiosks(title_id, zip)
      body = { :filters => 
               { 
                 :proximity => 
                 { 
                   :lat => 39.3668174, 
                   :lng =>  -76.670948, 
                   :radius => 50 
                  }
                } 
             },
             { :resultOptions => 
               { 
                 :max => 50, 
                 :profile => true, 
                 :status => true, 
                 :proximity => true, 
                 :user => true, 
                 :inventory => true, 
                 :invetoryProducts => [title_id]
                }
              }
      headers = {"cookie" => "rbuser=Validation=5u/UfKCJpwFUJOW0wYNsZrUJ/1Wc/yOL4HF3zhsxTC8=; RB_2.0=1; _json=%7B%22isBlurayWarningEnabled%22%3A%22true%22%2C%22isGamesWarningEnabled%22%3A%22true%22%2C%22locationSearchValue%22%3A%22%5C%2221209%5C%22%22%7D; s_vi=[CS]v1|268A179C851D2012-6000010160000D1E[CE]; ASP.NET_SessionId=oszj4v53yetgxjiiouic4cg4; LB=1518497546.0.0000; s_cc=true; c_m=undefinedDirect%20LoadDirect%20Load; s_sq=%5B%5BB%5D%5D", "__K" => "uFyVRI4STRLYVcsJY2zC92etFBe6N/ef19yTBpaRipY=", "Referer" => "http://www.redbox.com/"}             
      self.post("/api/Store/GetStores/", :body => body.to_json, :headers => headers)
    end
  end
end