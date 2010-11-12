require "nokogiri"

module YahooFinance
    class ISIN
        CSS_SELECTORS = {
            :home_exchange  => "td.yfnc_h",
            :exchanges      => "td.yfnc_tabledata1"
        }

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
            @doc = Nokogiri::HTML(open("http://uk.finsearch.yahoo.com/uk/index.php?nm=#{@isin}")) if @doc.nil?
        end
        
        def parse_document
            # This is pretty messy
            @doc.css(".yfnc_tableout1 tr").map do |row|
                home_exchange = row.css(CSS_SELECTORS[:home_exchange]).map do |cell|
                    cell.content.strip
                end
                @exchanges << Exchange.new(:home_exchange => true,:yahoo_symbol => home_exchange[1],:exchange => home_exchange[3]) if !home_exchange.empty? 

                other_exchange = row.css(CSS_SELECTORS[:exchanges]).map do |cell|
                    cell.content.strip
                end
                @exchanges << Exchange.new(:home_exchange => false, :yahoo_symbol => other_exchange[1],:exchange => other_exchange[3]) if !other_exchange.empty?
            end
            @exchanges.compact!
        end

        def has_doc
            !@doc.nil?            
        end
    end

    class Exchange
        attr_accessor :exchange,:currency,:yahoo_symbol,:home_exchange
        def initialize(hash)
            hash.each do |key,value|
                self.send(key.to_s+"=",value)
            end
        end
    end
end
