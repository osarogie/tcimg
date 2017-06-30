require 'open-uri'

class ImagesController < ApplicationController
  before_action :get_picture, except: [:index, :with_params]

  def index
    render plain: 'Welcome to the CDN of TheCommunity'
  end

  def fit
    send_data @data.read,
      type: 'image/jpeg',
      disposition: 'inline',
      stream: 'true',
      buffer_size: '4096'
  end

  def max_width

  end

  def with_params
    folder = File.join Rails.root, 'tmp', 'images'
    FileUtils.mkdir_p(folder) unless File.exist?(folder)

    file = request.fullpath.gsub('/', '_')
    file_location = File.join folder, file

    aws_folder = 'http://thecommunity-assets.s3.amazonaws.com/uploads'
    download_link = "http://cdn.filter.to/#{params[:img_params]}/#{aws_folder}/#{params[:image]}"

    unless File.exists?(file_location)
      download_image(download_link, file_location) rescue render_404 and return
    end

    send_file file_location, :disposition => 'inline', :type => 'image/jpeg', :x_sendfile => true
  end

  private
  def get_picture
    @width = params[:width]
    @height = params[:height]
    @uri = params[:image]

    @data = open("https://thecommunity-assets.s3.amazonaws.com/uploads/#{@uri}")
  rescue # TODO put a specific error class here ideally
    render plain: 'Image cannot be processed', status: 500
  end

  def download_image(url, dest)
    open(url) do |u|
      File.open(dest, 'wb') { |f| f.write(u.read) }
    end
  end
end
