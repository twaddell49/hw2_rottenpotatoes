class MoviesController < ApplicationController
  #sources: StackOverflow
  #collaborators: Chad Bryant, John Ursery
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings        #instantiate @all_ratings by making a call to method get_ratings defined in Movie model
    

    @sort = params[:sort]                   #instantiate @sort to URI sort parameter
    @checked_ratings = []                   #instantiate @checked_ratings empty array. Use: keep track of checked ratings

    if (params[:sort])                      #execute if params[:sort] exists.  Occurs after sort link is clicked
      session[:sort] = params[:sort]        #if it exists, instantiate session[:sort] to the value
    end

    if (params[:ratings])                   #execute if params[:ratings] exists.  Occurs after boxes are checked
      session[:ratings] = params[:ratings]  #if it exists, instantiate session[:ratings] to the value
      params[:ratings].each_key do |k|      #iterate through keys of params[:ratings], and for each key, 
        @checked_ratings << k               #append that key to @checked_ratings 
      end
      @movies = Movie.find(:all, :order => @sort, :conditions => {:rating => @checked_ratings})   #set @movies to all movies in the database with the same ratings that are stored in @checked_ratings, while keeping the order from @sort
    else
      if (session[:ratings])                                                    #if session[:ratings] exists
        flash.keep                                                              #do not overwrite message in flash
        redirect_to(:sort => session[:sort], :ratings => session[:ratings])     #and redirect to URI with previous parameters still existing
      end
      @movies = Movie.order(@sort).all      #set @movies to all movies in the database with the column designated by @sort ordered
    end
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
