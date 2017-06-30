class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_404
    render plain: 'We can\'t find that', status: 404
  end
end
