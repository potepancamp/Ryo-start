class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent
  protect_from_forgery with: :exception

  CATEGORY_NAMES = %w(Clothing Caps Bags Mugs).freeze

  CATEGORY_IMAGE_MAP = {
    'Clothing' => 'cloth.jpg',
    'Caps'     => 'cap.jpg',
    'Bags'     => 'bag.jpg',
    'Mugs'     => 'tableware.jpg'
  }.freeze

  before_action :set_category_link

  unless Rails.env.development?
    rescue_from Exception,                      with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
  end

  def get_ancestors(taxon)
    # 自身を含む先祖を取得し、最上位カテゴリ（parent_idがnil）を除外、階層順に並び替え
    taxon.self_and_ancestors.where.not(parent_id: nil).order(:lft)
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def _render_404(e: nil)
    logger.info("Rendering 404 with exception: #{e.message}") if e
    render "errors/404.html", status: :not_found, layout: "error"
  end

  def _render_500(e)
    logger.error("Rendering 500 with exception: #{e.message}")
    render "errors/500.html", status: :internal_server_error, layout: "error"
  end

  def set_category_link
    @categories = Spree::Taxon.where(name: CATEGORY_NAMES)
    @category_image_map = CATEGORY_IMAGE_MAP
  end
end
