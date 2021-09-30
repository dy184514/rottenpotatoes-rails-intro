class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    
    if params[:sort] == "title"
      @movies.order!("title asc")
      @movie_title_class="hilite"
    elsif params[:sort] == "release_date"
      @movies.order!("release_date asc")
      @release_date_class="hilite"
    end
    
    @all_ratings=Movie.sort_ratings
    
    if params[:ratings]
      @show_ratings = params[:ratings].keys
      session[:rating] = @show_ratings
    elsif session[:rating]
      query = Hash.new
      session[:rating].each do |rating|
        query['ratings['+ rating + ']'] = 1
      end
      query['sort'] = params[:sort] if params[:sort]
      session[:rating] = nil
      flash.keep
      redirect_to movies_path(query)
    else
      @show_ratings = @all_ratings
    end

    @movies.where!(rating: @show_ratings)
  end

  def new
    # default: render 'new' template
  end

  def create
    byebug
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

end