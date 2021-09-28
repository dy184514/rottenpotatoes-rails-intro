class Movie < ActiveRecord::Base
    def self.rate
        rate=Array.new
        self.select("rating").uniq.each {|x| rate.push(x.rating)}
        rate.sort.uniq
    end
    
    def self.with_ratings(rating_list)
        if rating_list == nil
            self.rate
        end
        self.where("rating":rating_list)
    end
end
