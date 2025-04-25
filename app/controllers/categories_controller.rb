class CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    @products = Spree::Product.includes(master: [:images, :default_price]).in_taxon(@taxon)
    # 親タクソンを取得
    @ancestors = get_ancestors(@taxon)
  end
end
