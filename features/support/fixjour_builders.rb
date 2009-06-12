Fixjour do
  define_builder(Movie) do |klass, overrides|
    klass.new(:title => "Movie #{counter(:movie)}", 
              :rating => 'PG',
              :synopsis => 'Best movie ever.',
              :genre => 'Comedy')
  end

end


Fixjour.verify!
World(Fixjour)