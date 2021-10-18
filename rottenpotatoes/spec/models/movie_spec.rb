require 'rails_helper'
require 'patch'

describe Movie do

    it "responds to movie_with_id" do
        Movie.should respond_to(:movie_with_id)
    end

    describe "movie with ratings" do
        it "should return movie only with given ratings" do
            Movie.create('title': 'movie1', 'director': 'director1')
            id_1 =  Movie.where('director': 'director1').pluck('id')[0]
            expect( Movie.movie_with_id(id_1.to_s) ).to eq('movie1')
        end
    end

    it "responds to with_ratings" do
        Movie.should respond_to(:with_ratings)
    end

    describe "movie retirieval with id" do
        it "should return the movie with given id" do
            Movie.create('title': 'movie1', 'director': 'director1', 'rating': 'PG')
            Movie.create('title': 'movie2', 'director': 'director2', 'rating': 'G')
            Movie.create('title': 'movie3', 'director': 'director3', 'rating': 'R')
            Movie.create('title': 'movie4', 'director': 'director4', 'rating': 'PG')
            expect(Movie.with_ratings(['PG'], " ").pluck('title')).to include('movie1')
            expect(Movie.with_ratings(['PG'], " ").pluck('title')).to include('movie4')
            expect(Movie.with_ratings(['G'], " ").pluck('title')).to include('movie2')
            expect(Movie.with_ratings(['R'], " ").pluck('title')).to include('movie3')
            expect(Movie.with_ratings(['G'], " ").pluck('title')).not_to include('movie1')
            expect(Movie.with_ratings(['G'], " ").pluck('title')).not_to include('movie4')
            expect(Movie.with_ratings(['G'], " ").pluck('title')).not_to include('movie3')
            expect(Movie.with_ratings(['PG'], "title").pluck('title')).not_to include('movie3')
        end
    end


    it "responds to similar_to" do
        Movie.should respond_to(:similar_to)
    end

    describe "movie of same director - happy path." do
        it "should have the movies with same director and should not have movie with different director" do
            Movie.create('title': 'movie1', 'director': 'director1')
            id_1 =  Movie.where('director': 'director1').pluck('id')[0]
            Movie.create('title': 'movie2', 'director': 'director1') 
            Movie.create('title': 'movie3', 'director': 'director2')
            expect( Movie.similar_to(id_1.to_s).pluck(:title) ).to include('movie1')
            expect( Movie.similar_to(id_1.to_s).pluck(:title) ).to include('movie2')
            expect( Movie.similar_to(id_1.to_s).pluck(:title) ).not_to include('movie3')
        end
    end

    describe "movie of same diretor - sad path." do
        it "movie with no director should return nil" do
            Movie.create('title': 'movie1', 'director': "")
            id_1 =  (Movie.where('director': 'director').pluck('id')[0]).to_s
            expect(Movie.similar_to(id_1)).to eq("")
        end
    end

end 