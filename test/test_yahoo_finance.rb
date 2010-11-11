require 'helper'

class TestYahooFinance < Test::Unit::TestCase
    #setup do
        #@isin_object = YahooFinance::ISIN.map_symbols "DE0005190003"
    #end

    should "respond to home_exchange " do
        assert_respond_to :home_exchange
    end
    
end
