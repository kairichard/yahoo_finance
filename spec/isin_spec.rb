$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'yahoo_finance'

describe "YahooFinance ISIN" do
    before :all do
        @obj = YahooFinance::ISIN.new("DE0005190003")
    end

    context " gets initialized " do
       it "should recieve two specific methods before filling #exchanges" do
            @obj.should_receive :read_in_yahoo_page
            @obj.should_receive :parse_document
            @obj.exchanges
        end
    end

    context "the instance its self" do
        subject do
            YahooFinance::ISIN.new("DE0005190003")
        end

        it { should respond_to(:exchanges) }
        #it { should respond_to(:home_exchange) }

        its(:exchanges) { should be_kind_of(Array) }                      
        its(:exchanges) { should have_exactly(11).items }

        context " the exchanges " do
             it " should be cool" do
                @obj.exchanges[1].should be_kind_of(YahooFinance::Exchange)
                @obj.exchanges.map{|x| x if x.exchange == "FRA" }.compact.size.should == 1
                @obj.exchanges.map{|x| x if x.yahoo_symbol == "BMW.BE" }.compact.size.should == 1
            end
        end
        it "should return just what i need" do
            YahooFinance.get_HistoricalQuotes(@obj.exchanges.first.yahoo_symbol,Date.parse("2010-11-11"),Date.parse("2010-11-11")).first.close.should == 54.42
            YahooFinance.get_HistoricalQuotes("BMW.DE",Date.parse("2010-11-11"),Date.parse("2010-11-11")).first.close.should == 54.42
        end
    end
end
