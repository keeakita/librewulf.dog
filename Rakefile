require 'find'
require 'haml'

task default: %w[haml]

# Generate html files from haml
task :haml do
  forall_haml do |path|
    outfile = File.new(path[0..-6], 'w')
    engine = Haml::Engine.new(File.read(path))
    outfile.write(engine.render)
    outfile.close
  end
end

def forall_haml
  Find.find('./') do |path|
    # Exclude vendor
    if path.start_with? './vendor'
      Find.prune
    end

    # Only run on files
    if File::file? path
      if /\.html.haml$/.match path
        yield path
      end
    end
  end
end
