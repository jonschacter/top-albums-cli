class TopAlbums::Scraper
    URL = "https://api.ranker.com/lists/362151/items"
    
    def self.scrape
        resp = RestClient.get(URL)
        resp_hash = JSON.parse(resp.body, symbolize_names:true)
        array = resp_hash[:listItems]
        array.each.with_index do |album, i|
            if i #< 15       #uncomment before '<' to limit results
                #scrape id number from list
                id = album[:node][:id]
                link = "https://api.ranker.com/lists/362151/items/#{id}?propertyFetchType=SHOWN_ON_LIST_ONLY&useDefaultNodeLinks=&include=wikiText"
                resp = RestClient.get(link)
                #scrape album info from individual links
                album_hash = JSON.parse(resp.body, symbolize_names:true)
                property_array = album_hash[:node][:nodeProperties]

                rank = album_hash[:rank]
                name = album_hash[:node][:name]
                artist = property_array.find{ |p| p[:displayName] == "Artist" }[:propertyValue]
                year = property_array.find{ |p| p[:displayName] == "Release Date" }[:propertyValue]
                producer = property_array.find{ |p| p[:displayName] == "Producer" }[:propertyValue]
                bio = album_hash[:node][:nodeWiki][:wikiText]
                wiki = album_hash[:node][:nodeWiki][:wikiLink]

                #create album and assign properties
                a = TopAlbums::Album.create(name)
                a.rank = rank
                a.artist = artist
                a.year = year
                a.producer = producer
                a.bio = bio
                a.wiki = wiki
            end
        end
    end
end
