class TopAlbums::Producer
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
        self.all.each do |producer|
            hash[producer.name] = producer.albums.length
        end
        hash.sort_by{|k, v| -v}
    end
end