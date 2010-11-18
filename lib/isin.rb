require "nokogiri"

module YahooFinance
    class ISIN
        CSS_SELECTORS = {
            :exchanges      => "td"
        }

        URL = "http://uk.finsearch.yahoo.com/lookup?s=%"

        attr_reader :isin, :exchanges

        def initialize(isin)
            @isin = isin
            @exchanges = []
        end
        
        def isin=(value)
            # validate isin
            @isin = value
        end

        def home_exchange
            exchanges.collect do |exchange|
                exchange if exchange.home_exchange == true
            end.compact.pop
        end

        def exchanges=(value)            
            @exchanges = value
        end

        def exchanges
            if @exchanges.empty?
                read_in_yahoo_page
                parse_document 
            end
            @exchanges
        end 

        private
        def read_in_yahoo_page(options={})
            @doc = Nokogiri::HTML(open(YahooFinance::ISIN::URL.gsub("%",@isin))) if @doc.nil?
        end
        
        def parse_document
            # This is pretty messy
            @doc.css(".yui-dt tr").map do |row|
                other_exchange = row.css(CSS_SELECTORS[:exchanges]).map do |cell|
                    cell.content.strip
                end
                @exchanges << Exchange.new( :yahoo_symbol => other_exchange[0],:exchange => other_exchange[5]) if !other_exchange.empty?               
            end
            @exchanges.compact!
        end

        def has_doc
            !@doc.nil?            
        end
    end

    class Exchange
        attr_accessor :yahoo_symbol,:exchange
        def initialize(hash)
            hash.each do |key,value|
                self.send(key.to_s+"=",value)
            end
        end
    end
end
