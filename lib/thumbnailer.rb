require 'pathname'
require 'rmagick'

# Thrown when the compression step fails
class ImageCompressionException < Exception
end

# A class used to thumbnail generation
class Thumbnail
  PNGCRUSH_ARGS = ['-rem', 'alla', '-brute', '-reduce', '-ow'].freeze

  # Constructs a new thumbnail object for the image at the given path.
  #
  # @param file_path  the path to the image file
  # @param dest_path  the path of the directory to store the thumbnails in
  # @param width      the max width of images
  def initialize(file_path, dest_path='source/images/thumbnails', width=768)
    @file = File.new(file_path)
    @dest_path = Pathname.new(dest_path)
    @image = Magick::Image.read(@file).first
    @width = width
  end

  # Determines what the final file path of the thumbnail will be
  #
  # @return [String] the path to the output file
  def munge_filename
    extension = 'jpg'

    # Transparent PNGs stay PNGs
    if @image.format == 'PNG' && !@image.opaque?
      extension = 'png'
    end

    base = File.basename(@file.to_path, '.*')
    base + '.' + extension
  end

  # Performs the actual conversion into a thumbnail and writes the result to
  # disk.
  def convert
    thumb_data = @image.copy

    # Resize step
    if @image.columns > @width
      thumb_data.resize_to_fit!(768, @image.rows)
    end
    dest_file = (@dest_path + munge_filename).to_path

    # Compression step
    if @image.format == 'PNG' && !@image.opaque?
      thumb_data.write('png:' + dest_file)
      unless system('pngcrush', *PNGCRUSH_ARGS, dest_file)
        raise ImageCompressionException('pngcrush returned nonzero exit status'\
          '. Are you sure it\'s installed?')
      end
    else
      thumb_data.write('jpeg:' + dest_file) do |options|
        options.quality = 80
      end
    end
  end
end
