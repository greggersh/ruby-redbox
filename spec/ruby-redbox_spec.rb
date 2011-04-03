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
  end
end
