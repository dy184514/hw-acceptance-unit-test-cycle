require 'rails_helper'
require 'patch'

describe MoviesController do
  fixtures :movies

  describe 'new test' do
    it 'should do nothing' do
      get :new
      response.response_code.should==200
    end
  end

  describe 'index page' do 
    describe 'sorting' do
      it 'should be able to sort the movies by title from params' do
        expect(Movie).to receive(:with_ratings).with(['PG','G'], 'title').and_return(movies(:Lagaan, :Interstellar, :Joker).sort)
        get :index, {'ratings': {'PG':1, 'G':1}, 'field_to_sort': 'title', 'here': 1 }
        expect(response.status).to eq(200)
      end

      it 'should be able to sort the movies by title with session' do
        expect(Movie).to receive(:with_ratings).with(['PG','G'], 'title').and_return(movies(:Lagaan, :Interstellar, :Joker).sort)
        get :index, nil, {'ratings': ['PG', 'G'], 'field_to_sort': 'title' }
        expect(response.status).to eq(200)
      end

      it 'should be able to sort the movies by release_date with params' do
        expect(Movie).to receive(:with_ratings).with(['PG','G'], 'release_date').and_return(movies(:Lagaan, :Interstellar, :Joker).sort)
        get :index, {'ratings': {'PG':1, 'G':1}, 'field_to_sort': 'release_date', 'here': 1 }
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'show movie' do
    it 'should show the selected movie' do
      expect(Movie).to receive(:create!).with({'title': 'Lagaan', 'director': 'Ashutosh'}).and_return(movies(:Lagaan))
      post :create, :movie => {'title': 'Lagaan', 'director' => 'Ashutosh'}
      get :show, {'id': movies(:Lagaan).id}
      expect(response).to render_template("movies/show")
    end
  end

  describe 'create movie' do
    it 'should be able to create a movie' do
      expect(Movie).to receive(:create!).with({'title': 'Lagaan', 'director': 'Ashutosh'}).and_return(movies(:Lagaan))
      post :create, :movie => {'title': 'Lagaan', 'director' => 'Ashutosh'}
      expect(flash[:notice]).to match(/Lagaan was successfully created/)
      expect(response).to redirect_to(movies_path)
    end
  end

  describe 'edit movie' do
    it 'should to able to edit a movie' do
      expect(Movie).to receive(:create!).with({'title': 'Lagaan', 'director': 'Ashutosh'}).and_return(movies(:Lagaan))
      post :create, :movie => {'title': 'Lagaan', 'director' => 'Ashutosh'}
      get :edit, {'id': movies(:Lagaan).id.to_s}
      expect(response.status).to eq(200)
    end
  end

  describe 'update movie' do
    it 'should be able to update a movie' do
      expect(Movie).to receive(:find).with(movies(:Lagaan).id.to_s).and_return(movies(:Lagaan))
      post :create, :movie => {'title': 'Lagaan', 'director': 'Ashutosh'}
      expect(movies(:Lagaan)).to receive(:update_attributes!).with({'title': 'Lagaan', 'director': 'Ashu'}).and_return(movies(:Lagaan))
      put :update, {'id': movies(:Lagaan).id.to_s, :movie => {'title': 'Lagaan', 'director': 'Ashu'}}
      expect(response).to redirect_to(movie_path)
    end
  end

  describe 'delete movie' do
    it 'should be able to delete a movie' do
      expect(Movie).to receive(:create!).with({'title': 'Lagaan', 'director': 'Ashutosh'}).and_return(movies(:Lagaan))
      post :create, :movie => {'title': 'Lagaan', 'director': 'Ashutosh'}
      delete :destroy, {'id': movies(:Lagaan).id.to_s}
      expect(flash[:notice]).to match(/Movie 'Lagaan' deleted/)
      expect(response).to redirect_to(movies_path)
    end
  end

  describe 'Search movies by the same director' do

    it 'should search for similar movies - happy path' do
        expect(Movie).to receive(:create!).with({'title': 'Lagaan', 'director': 'Ashutosh'}).and_return(movies(:Lagaan))
        post :create, :movie => {'title': 'Lagaan', 'director': 'Ashutosh'}
        expect(Movie).to receive(:similar_to).with(movies(:Lagaan).id.to_s).and_return(movies(:Lagaan))
        get :search_director, { 'id': movies(:Lagaan).id.to_s  }
        expect(response.status).to eq(200)
    end

    it 'should search for similar movies - sad path' do
        expect(Movie).to receive(:create!).with({'title': 'Joker'}).and_return(movies(:Joker))
        post :create, :movie => {'title': 'Joker'}
        expect(Movie).to receive(:similar_to).with(movies(:Joker).id.to_s).and_return("")
        get :search_director, { 'id': movies(:Joker).id.to_s }
        expect(response.status).to eq(302)
        expect(flash[:notice]).to match(/has no director info/)
        expect(response).to redirect_to(movies_path)
    end
  end

end
