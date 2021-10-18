class Movie < ActiveRecord::Base
    def self.movie_with_id(id)
        Movie.where('id':id).pluck(:title)[0]
    end
    
    def self.similar_to(id)
        director=Movie.where('id':id).pluck(:director)[0]
        if (director=='' || director==nil)
            return ''
        else
            return Movie.where('director':director)
        end
    end
    
    def self.all_ratings
        self.distinct.pluck(:rating)
    end
    
    def self.with_ratings(ratings_list, to_sort)
        ratings_list.map!(&:upcase)
        ratings_list.nil? ? self.all.order(to_sort) : self.where('rating': ratings_list).order(to_sort)
    end

end
