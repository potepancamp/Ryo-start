class ProductsController < ApplicationController
  include TaxonUtils

  def show
    @product = Spree::Product.find(params[:id])
    @category = @product.taxons.first # 商品に関連するカテゴリを取得
    @ancestors = get_ancestors(@category)
    @item_count_options = (1..10).to_a.freeze
  end
end
