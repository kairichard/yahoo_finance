$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'yahoo_finance'

describe YahooFinance::ISIN do
    it "responds to map_symbols" do 
        YahooFinance::ISIN.should respond_to(:map_to_symbol)
    end

    #it "responds to map_symbols" do
        #yf = YahooFinance::ISIN.map_symbols "DE0005190003"
        #yf.should respond_to(:map_symbols)
    #end
end
