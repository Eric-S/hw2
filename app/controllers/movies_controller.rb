class MoviesController < ApplicationController
  @@all_ratings = ['G','PG','PG-13','R']

  def get_all_ratings
    return @@all_ratings
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    debugger
    @sort = params[:sort]
    @all_ratings = Movie.select("DISTINCT rating").collect {|r| r.rating}
    @selected_ratings = (params[:ratings].present? ? params[:ratings] : [])
    if not @selected_ratings.present?	#if no items are checked, set the filter to be based on all values
	@selected_ratings = @all_ratings
    else
	@selected_ratings = @selected_ratings.flatten.keep_if{|v|v != "1"}
    end
    @movies = Movie.where(:rating => @selected_ratings).order("#{@sort}").find(:all)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
