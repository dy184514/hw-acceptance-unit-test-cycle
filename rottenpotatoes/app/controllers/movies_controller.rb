class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings =Movie.all_ratings
    session.clear if(request.path =='/')
    if (params[:field_to_sort].present? )
      @to_sort = params[:field_to_sort]
    else
      @to_sort = ''
    end

    if (params[:ratings].present? )
      rating = params[:ratings].keys
      @ratings_to_show = rating
    else
      rating = @all_ratings
      @ratings_to_show = []
    end

    if(params[:here].present?)
      session[:ratings] = rating
      session[:field_to_sort] = @to_sort
      session[:ratings_to_show] = @ratings_to_show
    else
      rating = session[:ratings].present? ? session[:ratings] : rating
      @ratings_to_show = session[:ratings_to_show].present? ? session[:ratings_to_show] : @ratings_to_show
      @to_sort = session[:field_to_sort].present? ? session[:field_to_sort] : @to_sort
    end

    @movies = Movie.with_ratings(rating, @to_sort)
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def search_director
    @movie=Movie.movie_with_id(params[:id])
    @mov_id=params[:id]
    @movies=Movie.similar_to(params[:id])
    if(@movies == '')
      flash[:notice] = "'#{@movie}' has no director info"
      redirect_to movies_path
    end
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end
