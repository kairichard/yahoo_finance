$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'yahoo_finance'

describe "YahooFinance" do
    it "should consider ISINS to look up stock quotes" do
        YahooFinance.get_HistoricalQuotes("DE0005190003",Date.parse("2010-11-11"),Date.parse("2010-11-11")).first.close.should == 54.42
    end
end 
