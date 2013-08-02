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
    #set variable to track if params were updated with previous session
    @param_updated = false
    if not params[:sort].present? and session[:sort].present? and (params[:sort] != session[:sort])
	params[:sort] = session[:sort]
	@param_updated = true
    end
    if not params[:ratings].present? and session[:ratings].present? and (params[:ratings] != session[:ratings])
	params[:ratings] = session[:ratings]
	@param_updated = true
    end

    @sort = params[:sort]
    @all_ratings = get_all_ratings
    @selected_ratings = (params[:ratings].present? ? params[:ratings] : [])
    if not @selected_ratings.present?	#if no items are checked, set the filter to be based on all values
	@selected_ratings = @all_ratings
    else
	@selected_ratings = @selected_ratings.flatten.keep_if{|v|v != "1"}
    end
    @movies = Movie.where(:rating => @selected_ratings).order("#{@sort}").find(:all)
    
    #update session to match params
    session[:sort] = @sort
    session[:ratings] = @selected_ratings

    #redirect to remain RESTful with param values attached
    if @param_updated 
	redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    flash.keep
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    flash.keep
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    flash.keep
    redirect_to movies_path
  end

end
