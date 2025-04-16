class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent

  protect_from_forgery with: :exception

  before_action :category_link

  unless Rails.env.development?
    rescue_from Exception,                      with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def _render_404(e: nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e
    render "errors/404.html", status: :not_found, layout: "error"
  end

  def _render_500(e)
    logger.error "Rendering 500 with exception: #{e.message}" if e
    render "errors/500.html", status: :internal_server_error, layout: "error"
  end

  def category_link
    category_names = ["Clothing", "Caps", "Bags", "Mugs"]
    @categories = Spree::Taxon.where(name: category_names)
    binding.pry 
  end
end
