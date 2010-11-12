Autotest.add_discovery { "rspec2" }
Autotest.add_hook :initialize do |at|
    at.add_mapping(/^\/lib\/.*/) do |filename|
        filename
    end
end
