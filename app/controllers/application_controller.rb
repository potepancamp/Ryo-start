class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent

  before_action :home_category_link

  def home_category_link
    @clothing = Spree::Taxon.find_by(name: "Clothing")
    @caps = Spree::Taxon.find_by(name: "Caps")
    @bags = Spree::Taxon.find_by(name: "Bags")
    @mugs = Spree::Taxon.find_by(name: "Mugs")
  end

  protect_from_forgery with: :exception

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
end
