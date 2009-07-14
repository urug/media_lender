class MoviesController < ApplicationController
  before_filter :authenticate
  
  # GET /movies
  # GET /movies.xml
  def index
    @movies = current_user.movies
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @movies }
    end
  end
  
  def sorted
    @letter = params[:letter]
    if @letter.blank?
      @movies = current_user.movies
    elsif @letter == "numbers"
      @movies = current_user.movies.all_by_numbers
    else
      @movies = current_user.movies.all_by_letter(@letter)
    end
    render :action => "index"
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = current_user.movies.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.xml
  def new
    @movie = current_user.movies.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = current_user.movies.find(params[:id])
  end

  # POST /movies
  # POST /movies.xml
  def create
    @movie = current_user.movies.new(params[:movie])

    respond_to do |format|
      if @movie.save
        flash[:notice] = 'Movie was successfully created.'
        format.html { redirect_to(@movie) }
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    @movie = current_user.movies.find(params[:id])

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        flash[:notice] = 'Movie was successfully updated.'
        format.html { redirect_to(@movie) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    @movie = current_user.movies.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.xml  { head :ok }
    end
  end
end
