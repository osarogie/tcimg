require 'open-uri'

class ImagesController < ApplicationController
  before_action :get_picture, except: [:index]

  def index
    render plain: 'Welcome to the CDN of TheCommunity'
  end

  def fit
    send_data @data.read, type: @data.content_type, disposition: 'inline', stream: 'true', buffer_size: '4096' 
  end

  def max_width

  end

  private
  def get_picture
    @width = params[:width]
    @height = params[:height]
    @uri = params[:image]

    @data = open("https://thecommunity-assets.s3.amazonaws.com/uploads/#{@uri}")
  rescue # put a specific error class here ideally
    render plain: 'Image cannot be processed', status: 500
  end
end
