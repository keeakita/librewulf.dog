require 'find'
require_relative './lib/thumbnailer.rb'

task default: %w[build]

def clean_thumbnails
  sh 'rm -r ./source/images/thumbnails'
  sh 'mkdir -p ./source/images/thumbnails'
end

task :build do
  puts 'Generating thumbnails'

  clean_thumbnails

  Find.find('./source/images/gallery/') do |path|
    # Only run on files
    if File::file? path
      thumb = Thumbnail.new(path)
      puts "Generating #{thumb.munge_filename}"
      thumb.convert
    end
  end

  puts 'Building Middleman project'
  sh 'middleman build'
end

task :clean do
  clean_thumbnails
  sh 'rm -r ./build/'
end
