require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MoviesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "movies", :action => "index").should == "/movies"
    end
  
    it "maps #new" do
      route_for(:controller => "movies", :action => "new").should == "/movies/new"
    end
  
    it "maps #show" do
      route_for(:controller => "movies", :action => "show", :id => "1").should == "/movies/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "movies", :action => "edit", :id => "1").should == "/movies/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "movies", :action => "create").should == {:path => "/movies", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "movies", :action => "update", :id => "1").should == {:path =>"/movies/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "movies", :action => "destroy", :id => "1").should == {:path =>"/movies/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/movies").should == {:controller => "movies", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/movies/new").should == {:controller => "movies", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/movies").should == {:controller => "movies", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/movies/1").should == {:controller => "movies", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/movies/1/edit").should == {:controller => "movies", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/movies/1").should == {:controller => "movies", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/movies/1").should == {:controller => "movies", :action => "destroy", :id => "1"}
    end
  end
end
