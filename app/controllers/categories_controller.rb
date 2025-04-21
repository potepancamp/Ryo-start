class CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    @products = Spree::Product.includes(master: [:images, :default_price]).in_taxon(@taxon)
    
    # `parent_id` を利用して最上位タクソンを取得
    @ancestors = get_ancestors(@taxon)
  end

  private

  def get_ancestors(taxon)
    ancestors = []

    # 現在のタクソンを親タクソンがない最上位タクソンまでたどる
    while taxon.parent_id.present?
      ancestors.unshift(taxon)
      taxon = Spree::Taxon.find(taxon.parent_id)
    end
    ancestors.unshift(taxon)  # 最上位タクソンも追加

    ancestors
  end
end
