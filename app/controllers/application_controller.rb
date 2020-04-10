class ApplicationController < ActionController::API
  def render_404
    render plain: "We can't find that", status: 404
  end
end
