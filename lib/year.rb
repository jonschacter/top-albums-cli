class TopAlbums::Year
    extend Findable::ClassMethods
    extend Memorable::ClassMethods

    attr_accessor :name, :albums

    @@all = []

    def initialize(name)
        @name = name
        @albums = []
    end
    
    def save
        @@all << self
    end

    def self.all
        @@all
    end

    def self.album_count
        hash = {}
        self.all.each do |year|
            hash[year.name] = year.albums.length
        end
        hash.sort{|(k1, v1), (k2, v2)| [v2, k1] <=> [v1, k2]}.to_h
    end
end
