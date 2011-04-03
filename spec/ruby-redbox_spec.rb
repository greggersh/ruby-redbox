require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyRedbox" do
  describe "#get_titles" do
    context "when the request is successful" do
      before do
        @body = 'A string that is at least thirteen characters long and then some.'
        stub_request(:get, "http://www.redbox.com/api/product/js/titles").with(:headers => {'Accept'=>'*/*'}).to_return(:status => 200, :body => @body, :headers => {})
      end
      
      it "should chop off the beginning of the javascript and return the rest" do
        response = Redbox.get_titles
        response.should == @body[13..-1]
      end
    end
    
    context "when the request is not successful" do
      before do
        stub_request(:get, "http://www.redbox.com/api/product/js/titles").to_return(:status => [404, "Not Found"])      
      end
      
      it "should return an error message" do
        response = Redbox.get_titles
        response.should == "Not Found"
      end
    end
  end
  
  describe "#nearest_kiosks" do
    context "when the request returns an error" do
      before do
        @body = "{\"d\":{\"success\":false,\"msg\":\"We\\u0027re sorry, the request failed.  Please try again later.\",\"data\":null}}"
        stub_request(:post, "http://www.redbox.com/api/Store/GetStores/").to_return(:status => 200, :body => @body)
      end
      
      it "should return a string with the msg content" do
        nearest_kiosks = Redbox.find_nearest_kiosks(1, 36, -76)
        nearest_kiosks.should == "We're sorry, the request failed.  Please try again later."
      end
    end
    
    context "when the request returns a list of kiosks" do
      before do
        @body = '{"d":{"success":true,"msg":null,"data":[{"id":21627,"profile":{"vendor":"Royal Farms","name":"","addr":"2330 Smith Ave","city":"Baltimore","state":"MD","zip":"21209-2611","indoor":false},"proximity":{"lat":39.375387,"lng":-76.676758,"dist":0.2,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":7165,"profile":{"vendor":"Shoppers Food & Pharmacy","name":"Machine A","addr":"2801 Smith Ave","city":"Baltimore","state":"MD","zip":"21209-1426","indoor":true},"proximity":{"lat":39.375890,"lng":-76.691209,"dist":0.6,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":24978,"profile":{"vendor":"Shoppers Food & Pharmacy","name":"Machine B","addr":"2801 Smith Ave","city":"Baltimore","state":"MD","zip":"21209-1426","indoor":false},"proximity":{"lat":39.375890,"lng":-76.691209,"dist":0.6,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":29441,"profile":{"vendor":"Walgreens","name":"","addr":"2560 Quarry Lake Dr","city":"Baltimore","state":"MD","zip":"21209-3759","indoor":false},"proximity":{"lat":39.384977,"lng":-76.686714,"dist":0.8,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":29842,"profile":{"vendor":"Royal Farms","name":"","addr":"6067 Falls Rd","city":"Baltimore","state":"MD","zip":"21209-2215","indoor":false},"proximity":{"lat":39.372588,"lng":-76.649918,"dist":1.6,"drv":true},"inventory":{"products":[{"id":4292,"stock":false}]},"status":{"online":true},"user":null},{"id":6440,"profile":{"vendor":"Giant","name":"","addr":"6620 Reisterstown Rd","city":"Baltimore","state":"MD","zip":"21215-2305","indoor":true},"proximity":{"lat":39.357510,"lng":-76.704226,"dist":1.7,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":5714,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"4205 Mortimer Ave # 15","city":"Baltimore","state":"MD","zip":"21215-3302","indoor":true},"proximity":{"lat":39.348081,"lng":-76.693667,"dist":1.9,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":11432,"profile":{"vendor":"Food King ","name":"","addr":"5700 Wabash Ave","city":"Baltimore","state":"MD","zip":"21215-3203","indoor":true},"proximity":{"lat":39.346322,"lng":-76.697667,"dist":2.1,"drv":true},"inventory":{"products":[]},"status":{"online":true},"user":null},{"id":6725,"profile":{"vendor":"Giant","name":"","addr":"3757 Old Court Rd","city":"Pikesville","state":"MD","zip":"21208-3902","indoor":true},"proximity":{"lat":39.378965,"lng":-76.724713,"dist":2.4,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":5653,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"4401 Reisterstown Rd","city":"Baltimore","state":"MD","zip":"21215-6203","indoor":true},"proximity":{"lat":39.338956,"lng":-76.667933,"dist":2.5,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":13976,"profile":{"vendor":"Stop Shop Save","name":"","addr":"2701 W Cold Springs Ln","city":"Baltimore","state":"MD","zip":"21215-6701","indoor":true},"proximity":{"lat":39.339593,"lng":-76.666413,"dist":2.5,"drv":true},"inventory":{"products":[]},"status":{"online":true},"user":null},{"id":18909,"profile":{"vendor":"Graul\u0027s Market","name":"","addr":"7713 Bellona Ave","city":"Ruxton","state":"MD","zip":"21204-6501","indoor":false},"proximity":{"lat":39.398690,"lng":-76.645123,"dist":2.5,"drv":true},"inventory":{"products":[{"id":4292,"stock":false}]},"status":{"online":true},"user":null},{"id":5708,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"1706 Reisterstown Rd","city":"Baltimore","state":"MD","zip":"21208-2903","indoor":false},"proximity":{"lat":39.381957,"lng":-76.730885,"dist":2.8,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":21635,"profile":{"vendor":"Royal Farms","name":"","addr":"1630 W Joppa Rd","city":"Ruxton","state":"MD","zip":"21204-1954","indoor":false},"proximity":{"lat":39.409400,"lng":-76.647729,"dist":3.0,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":5671,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"6005 Liberty Rd","city":"Baltimore","state":"MD","zip":"21207-6206","indoor":false},"proximity":{"lat":39.336991,"lng":-76.712740,"dist":3.1,"drv":true},"inventory":{"products":[{"id":4292,"stock":false}]},"status":{"online":false},"user":null},{"id":30713,"profile":{"vendor":"7-Eleven","name":"","addr":"1 Greenwood Pl","city":"Pikesville","state":"MD","zip":"21208-2763","indoor":false},"proximity":{"lat":39.373942,"lng":-76.739858,"dist":3.2,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":34282,"profile":{"vendor":"Royal Farms","name":"","addr":"1119 W 41st St","city":"Baltimore","state":"MD","zip":"21211-1637","indoor":true},"proximity":{"lat":39.337846,"lng":-76.636283,"dist":3.4,"drv":true},"inventory":{"products":[{"id":4292,"stock":false}]},"status":{"online":true},"user":null},{"id":24368,"profile":{"vendor":"Royal Farms","name":"","addr":"206 W Cold Spring Ln","city":"Baltimore","state":"MD","zip":"21210-2802","indoor":true},"proximity":{"lat":39.344962,"lng":-76.627271,"dist":3.5,"drv":true},"inventory":{"products":[{"id":4292,"stock":false}]},"status":{"online":true},"user":null},{"id":18226,"profile":{"vendor":"Giant","name":"","addr":"711 W 40th St","city":"Baltimore","state":"MD","zip":"21211-2120","indoor":true},"proximity":{"lat":39.337211,"lng":-76.628650,"dist":3.7,"drv":true},"inventory":{"products":[{"id":4292,"stock":false}]},"status":{"online":true},"user":null},{"id":6439,"profile":{"vendor":"Giant","name":"","addr":"6340 York Rd # 50","city":"Baltimore","state":"MD","zip":"21212-2361","indoor":true},"proximity":{"lat":39.372657,"lng":-76.609792,"dist":3.8,"drv":true},"inventory":{"products":[{"id":4292,"stock":false}]},"status":{"online":true},"user":null},{"id":30565,"profile":{"vendor":"Royal Farms","name":"","addr":"3611 Roland Ave","city":"Baltimore","state":"MD","zip":"21211-2408","indoor":true},"proximity":{"lat":39.331272,"lng":-76.632671,"dist":3.9,"drv":true},"inventory":{"products":[{"id":4292,"stock":false}]},"status":{"online":true},"user":null},{"id":29845,"profile":{"vendor":"Royal Farms","name":"","addr":"7204 York Rd","city":"Baltimore","state":"MD","zip":"21212-1527","indoor":false},"proximity":{"lat":39.382690,"lng":-76.607335,"dist":3.9,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":5674,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"5100 York Rd","city":"Baltimore","state":"MD","zip":"21212-4307","indoor":true},"proximity":{"lat":39.350880,"lng":-76.609719,"dist":4.1,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":21613,"profile":{"vendor":"Royal Farms","name":"","addr":"501 W Seminary Ave","city":"Lutherville","state":"MD","zip":"21093-5015","indoor":false},"proximity":{"lat":39.423046,"lng":-76.633194,"dist":4.2,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":13168,"profile":{"vendor":"Shoppers Food & Pharmacy","name":"","addr":"2000 Gwynn\u0027s Falls Pkwy","city":"Baltimore","state":"MD","zip":"21216-3244","indoor":true},"proximity":{"lat":39.315950,"lng":-76.651600,"dist":4.3,"drv":false},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null},{"id":13979,"profile":{"vendor":"Stop Shop Save","name":"","addr":"3427 Clifton Ave","city":"Baltimore","state":"MD","zip":"21216-2502","indoor":true},"proximity":{"lat":39.310965,"lng":-76.674796,"dist":4.4,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":18225,"profile":{"vendor":"Stop & Shop","name":"","addr":"3602 Milford Mill Rd","city":"Baltimore","state":"MD","zip":"21244-3328","indoor":true},"proximity":{"lat":39.354171,"lng":-76.758121,"dist":4.4,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":29469,"profile":{"vendor":"Walgreens","name":"","addr":"8050 Liberty Rd","city":"Baltimore","state":"MD","zip":"21244-2968","indoor":false},"proximity":{"lat":39.353560,"lng":-76.757737,"dist":4.4,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":29844,"profile":{"vendor":"Royal Farms","name":"","addr":"6416 Windsor Mill Rd","city":"Baltimore","state":"MD","zip":"21207-6005","indoor":false},"proximity":{"lat":39.321871,"lng":-76.726609,"dist":4.4,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":7168,"profile":{"vendor":"Shoppers Food & Pharmacy","name":"","addr":"8212 Liberty Rd.","city":"Baltimore","state":"MD","zip":"21244-3035","indoor":true},"proximity":{"lat":39.355744,"lng":-76.763938,"dist":4.6,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":5649,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"8227 Liberty Rd","city":"Baltimore","state":"MD","zip":"21244-3033","indoor":false},"proximity":{"lat":39.355852,"lng":-76.764227,"dist":4.7,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":13981,"profile":{"vendor":"Stop Shop Save","name":"","addr":"5600 The Alameda","city":"Baltimore","state":"MD","zip":"21239-2737","indoor":true},"proximity":{"lat":39.356874,"lng":-76.595674,"dist":4.7,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":6437,"profile":{"vendor":"Giant","name":"","addr":"601 E 33rd St","city":"Baltimore","state":"MD","zip":"21218-3505","indoor":true},"proximity":{"lat":39.328320,"lng":-76.608449,"dist":5.0,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":12444,"profile":{"vendor":"Walmart","name":"","addr":"9750 Reisterstown Rd Ste A","city":"Owings Mills","state":"MD","zip":"21117-4147","indoor":true},"proximity":{"lat":39.407280,"lng":-76.762718,"dist":5.0,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":46629,"profile":{"vendor":"Walgreens","name":"","addr":"1801 York Rd","city":"Lutherville","state":"MD","zip":"21093-5119","indoor":false},"proximity":{"lat":39.430288,"lng":-76.621518,"dist":5.0,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":5726,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"6502 Security Blvd","city":"Baltimore","state":"MD","zip":"21207-5106","indoor":true},"proximity":{"lat":39.312199,"lng":-76.732160,"dist":5.1,"drv":true},"inventory":null,"status":{"online":false},"user":null},{"id":13977,"profile":{"vendor":"Stop Shop Save","name":"","addr":"1400 N Monroe St","city":"Baltimore","state":"MD","zip":"21217-1541","indoor":true},"proximity":{"lat":39.304123,"lng":-76.647838,"dist":5.1,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":5706,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"2840 Greenmount Ave","city":"Baltimore","state":"MD","zip":"21218-4429","indoor":true},"proximity":{"lat":39.323095,"lng":-76.609434,"dist":5.2,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":52994,"profile":{"vendor":"PriceRite","name":"","addr":"6606 Security Blvd","city":"Woodlawn","state":"MD","zip":"21207-4010","indoor":true},"proximity":{"lat":39.312380,"lng":-76.735370,"dist":5.2,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":5721,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"1600 Argonne Dr","city":"Baltimore","state":"MD","zip":"21218-1638","indoor":true},"proximity":{"lat":39.340180,"lng":-76.591359,"dist":5.3,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":7198,"profile":{"vendor":"Shoppers Food & Pharmacy","name":"","addr":"803 Goucher Blvd.","city":"Towson","state":"MD","zip":"21286-5602","indoor":true},"proximity":{"lat":39.398927,"lng":-76.586722,"dist":5.3,"drv":true},"inventory":null,"status":{"online":false},"user":null},{"id":18227,"profile":{"vendor":"Giant","name":"","addr":"9934 Reisterstown Rd","city":"Owings Mills","state":"MD","zip":"21117-3945","indoor":true},"proximity":{"lat":39.410822,"lng":-76.767911,"dist":5.3,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":5656,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"2116 York Rd","city":"Timonium","state":"MD","zip":"21093-3108","indoor":true},"proximity":{"lat":39.442016,"lng":-76.626881,"dist":5.5,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":5690,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"1655 Belmont Ave","city":"Baltimore","state":"MD","zip":"21244-2521","indoor":true},"proximity":{"lat":39.314274,"lng":-76.749333,"dist":5.5,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":5751,"profile":{"vendor":"McDonald\u0027s","name":"","addr":"6834 Loch Raven Blvd","city":"Baltimore","state":"MD","zip":"21286-8301","indoor":false},"proximity":{"lat":39.383217,"lng":-76.578226,"dist":5.5,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":21723,"profile":{"vendor":"Royal Farms","name":"","addr":"5 E Timonium Rd","city":"Timonium","state":"MD","zip":"21093-3421","indoor":false},"proximity":{"lat":39.440912,"lng":-76.625878,"dist":5.5,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":6435,"profile":{"vendor":"Giant","name":"","addr":"4624 Edmondson Ave","city":"Baltimore","state":"MD","zip":"21229-1407","indoor":true},"proximity":{"lat":39.293310,"lng":-76.696159,"dist":5.6,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":29460,"profile":{"vendor":"Walgreens","name":"Machine A","addr":"2204 N Rolling Rd","city":"Baltimore","state":"MD","zip":"21244-1825","indoor":false},"proximity":{"lat":39.320026,"lng":-76.758023,"dist":5.6,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":35609,"profile":{"vendor":"Giant","name":"","addr":"2145 York Rd","city":"Timonium","state":"MD","zip":"21093-3110","indoor":true},"proximity":{"lat":39.443200,"lng":-76.627405,"dist":5.6,"drv":true},"inventory":null,"status":{"online":true},"user":null},{"id":45386,"profile":{"vendor":"Walgreens","name":"Machine B","addr":"2204 N Rolling Rd","city":"Baltimore","state":"MD","zip":"21244-1825","indoor":false},"proximity":{"lat":39.320026,"lng":-76.758023,"dist":5.6,"drv":true},"inventory":null,"status":{"online":true},"user":null}]}}'
        stub_request(:post, "http://www.redbox.com/api/Store/GetStores/").to_return(:status => 200, :body => @body)
        @kiosks = Redbox.find_nearest_kiosks(4292, 39.48474, -76.9494)
      end
      
      it "should return a list of kiosks" do
        @kiosks.is_a?(Array).should be_true
        @kiosks.should_not be_empty
      end
      
      it "should parse the data into a kiosk object for each record" do
        'data":[{"id":21627,"profile":{"vendor":"Royal Farms","name":"","addr":"2330 Smith Ave","city":"Baltimore","state":"MD","zip":"21209-2611","indoor":false},"proximity":{"lat":39.375387,"lng":-76.676758,"dist":0.2,"drv":true},"inventory":{"products":[{"id":4292,"stock":true}]},"status":{"online":true},"user":null}'
        @kiosks.first.vendor.should == "Royal Farms"
        @kiosks.first.address.should == "2330 Smith Ave"
        @kiosks.first.city.should == "Baltimore"
        @kiosks.first.state.should == "MD"
        @kiosks.first.zip.should == "21209-2611"
        @kiosks.first.indoor.should == false
        @kiosks.first.distance.should == 0.2
        @kiosks.first.in_stock.should == true
      end
    end    
  end
end
