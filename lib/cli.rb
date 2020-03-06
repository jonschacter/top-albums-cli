class TopAlbums::CLI

    def call
        puts "Loading... this may take a few minutes"
        TopAlbums::Scraper.scrape
        welcome
        input = nil
        while input != "exit"
            puts "To view the greatest albums of all time according to Ranker.com users type 'list'."
            puts "To view more commands type 'help' or type 'exit' to exit."
            input = gets.strip

            case input
            when "help"
                command_list
            when "list"
                list_albums
            when "list-year"
                list_year
            when "artist-count"
                artist_count
            when "producer-count"
                producer_count
            when "year-count"
                year_count
            when "info"
                more_info
            when "filter-artist"
                filter_artist
            when "filter-producer"
                filter_producer
            when "filter-year"
                filter_year
            when "range"
                display_range
            end
        end
    end

    def welcome
        thick_divider
        puts " __          __  _                          _ "
        puts " \\ \\        / / | |                        | |"
        puts "  \\ \\  /\\  / /__| | ___ ___  _ __ ___   ___| |"
        puts "   \\ \\/  \\/ / _ \\ |/ __/ _ \\| '_ ` _ \\ / _ \\ |"
        puts "    \\  /\\  /  __/ | (_| (_) | | | | | |  __/_|"
        puts "     \\/  \\/ \\___|_|\\___\\___/|_| |_| |_|\\___(_)"
        thick_divider
    end

    def thick_divider
        puts "=============================================="
        puts "**********************************************"
        puts "=============================================="
    end

    def thin_divider
        puts "=============================================="
    end

    def command_list
        thin_divider
        puts "'list'            - view full list"
        puts "'list-year'       - sort full list by year"
        puts "'artist-count'    - show number of list entries from each artist"
        puts "'producer-count'  - show number of list entries from each producer"
        puts "'year-count'      - show number of list entries from each year"
        puts "'info'            - show more info on a specific entry"
        puts "'filter-artist'   - show all list entries by specific artist"
        puts "'filter-producer' - show all list entries by specific producer"
        puts "'filter-year'     - show all list entries by specific year"
        puts "'range'           - display only a range of the list"
        puts "'exit'            - quit"
        thin_divider
    end

    def input_error
        puts "Input not recognized. Please check spelling and try again."
    end

    def display_list_line(album)
        puts "#{album.rank}. #{album.name} - #{album.artist.name} (#{album.year.name})"
    end

    def list_albums
        thin_divider
        puts "# Title - Artist (Year)"
        thin_divider
        TopAlbums::Album.sort_by_rank.each do |album|
            display_list_line(album)
        end
        thick_divider
    end

    def list_year
        thin_divider
        puts "# Title - Artist (Year)"
        thin_divider
        TopAlbums::Album.sort_by_year.each do |album|
            if album.year.name != ""
                display_list_line(album)
            end
        end
        thick_divider
    end

    def more_info
        input = nil
        while input != "menu" || input != "exit"
            puts "Please enter the rank# or exact name of the album you would like more info on or type 'menu' to return to main menu"
            input = gets.strip

            if input.to_i.to_s == input && input.to_i.between?(1, TopAlbums::Album.all.length)
                album = TopAlbums::Album.find_by_rank(input.to_i)
                display_info(album)
            elsif album = TopAlbums::Album.find_by_name(input.split.map{|i|i.capitalize}.join(" "))
                display_info(album)
            elsif input != "menu" || input != "exit"
                input_error
            end
        end
        thick_divider
    end

    def display_info(album_obj)
        thin_divider
        puts "Name:             #{album_obj.name}"
        puts "Artist:           #{album_obj.artist.name}" if album_obj.artist
        puts "Year:             #{album_obj.year.name}" if album_obj.year
        puts "Producer:         #{album_obj.producer.name}" if album_obj.producer
        puts "Current Rank:     #{album_obj.rank}"
        puts "Wiki URL:         #{album_obj.wiki}" if album_obj.wiki
        puts "Bio:              #{album_obj.bio}" if album_obj.bio
        thin_divider
    end

    def artist_count
        thin_divider
        TopAlbums::Artist.album_count.each do |k, v| 
            if k != ""
                puts "#{k} - #{v}"
            end
        end
        thin_divider
    end

    def producer_count
        thin_divider
        TopAlbums::Producer.album_count.each do |k, v| 
            if k != ""
                puts "#{k} - #{v}"
            end
        end
        thin_divider
    end

    def year_count
        thin_divider
        TopAlbums::Year.album_count.each do |k, v| 
            if k != ""
                puts "#{k} - #{v}"
            end
        end
        thin_divider
    end

    def filter_artist
        input = nil

        while input != "Menu" || input != "Exit"
            puts "Please enter the exact name of the artist or type 'menu' to return to main menu."
            input = gets.strip.split.map{|i|i.capitalize}.join(" ")

            if artist = TopAlbums::Artist.find_by_name(input)
                thin_divider
                TopAlbums::Album.sort_by_rank.each do |album|
                    if album.artist == artist
                        display_list_line(album)
                    end
                end
                thin_divider
            elsif input != "Menu" || input != "Exit"
                input_error
            end
        end
        thick_divider
    end

    def filter_producer
        input = nil

        while input != "Menu" || input != "Exit"
            puts "Please enter the exact name of the producer or type 'menu' to return to main menu."
            input = gets.strip.split.map{|i|i.capitalize}.join(" ")

            if producer = TopAlbums::Producer.find_by_name(input)
                thin_divider
                TopAlbums::Album.sort_by_rank.each do |album|
                    if album.producer == producer
                        display_list_line(album)
                    end
                end
                thin_divider
            elsif input != "Menu" || input != "Exit"
                input_error
            end
        end
        thick_divider
    end

    def filter_year
        input = nil

        while input != "menu" || input != "exit"
            puts "Please enter the year or type 'menu' to return to main menu."
            input = "#{gets.strip}"

            if year = TopAlbums::Year.find_by_name(input)
                thin_divider
                TopAlbums::Album.sort_by_rank.each do |album|
                    if album.year == year
                        display_list_line(album)
                    end
                end
                thin_divider
            elsif input.to_i.to_s == input && input.to_i.between?(0, Time.now.year)
                puts "#{input} does not appear on this list"
            elsif input != "menu" || input != "exit"
                input_error
            end
        end
        thick_divider
    end

    def display_range
        puts "Please enter starting point"
        start_input = gets.strip
        puts "Please enter ending point"
        stop_input = gets.strip
        thin_divider
        TopAlbums::Album.sort_by_rank.each do |album|
            if album.rank.to_i.between?(start_input.to_i, stop_input.to_i)
                display_list_line(album)
            end
        end
        thin_divider
    end
end