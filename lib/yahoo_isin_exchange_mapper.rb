require "nokogiri"

module YahooFinance
    ISIN_SEARCH_HASH = {
        "nm" => ["isin"]
    }    
    class ISIN
        def self.map_to_symbol(isin,options={})
            # validate isin
            doc = Nokogiri::HTML(open("http://uk.finsearch.yahoo.com/uk/index.php?nm=#{isin}"))
            doc.css(".yfnc_h").each do |cell|
                puts cell.content
            end
            
        end
    end



end
