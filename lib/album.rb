class TopAlbums::Album
    extend Findable::ClassMethods
    extend Memorable::ClassMethods
    
    attr_accessor :name, :year, :rank, :bio, :wiki, :listen_status
    attr_reader :artist, :producer

    @@all = []

    def initialize(name)
        @name = name
        @listen_status = "N"
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end

    def artist=(artist_name)
        @artist = TopAlbums::Artist.find_or_create_by_name(artist_name)
        @artist.albums << self
    end

    def producer=(producer_name)
        @producer = TopAlbums::Producer.find_or_create_by_name(producer_name)
        @producer.albums << self
    end

    def year=(year_name)
        @year = TopAlbums::Year.find_or_create_by_name(year_name)
        @year.albums << self
    end

    def self.find_by_rank(rank)
        self.all.find{|a| a.rank == rank}
    end

    def self.sort_by_rank
        self.all.sort{|a,b| a.rank <=> b.rank}
    end

    def self.sort_by_year
        self.all.sort{|a,b| a.year.name <=> b.year.name}
    end
end
