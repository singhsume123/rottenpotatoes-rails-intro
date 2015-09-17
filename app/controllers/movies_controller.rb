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

    @all_ratings = Movie.All_Ratings

    sort = params[:sort] || session[:sort]
    
    ratings = params[:ratings] || session[:ratings]

    if params[:sort] != session[:sort]
       session[:sort] = sort
       flash.keep
       redirect_to movies_path :sort => sort, :ratings => ratings and return
    end
     
    if params[:ratings] != session[:ratings]
       session[:ratings] = ratings
       flash.keep
       redirect_to movies_path :sort => sort, :ratings => ratings and return
    end

    if sort == "title"
       @title_header = "hilite"
    elsif sort == "release_date"
        @release_date_header = "hilite"
    end 

    if ratings 
        @checked = []
        ratings.each do |a,b|
           @checked += [a]
        end
        if sort
            @movies = Movie.where("rating IN (?)", @checked).order(sort).all
        else  
            @movies = Movie.where("rating IN (?)", @checked)
        end
    else
      if sort
        @movies = Movie.order(sort).all
      else
        @movies = Movie.all
      end 
    end  
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

end
