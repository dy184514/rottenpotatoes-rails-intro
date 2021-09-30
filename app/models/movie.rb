class Movie < ActiveRecord::Base
    def self.sort_ratings
       return ["G","PG","PG-13","R"]
    end
end
