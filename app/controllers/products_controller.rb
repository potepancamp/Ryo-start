class ProductsController < ApplicationController
  include AncestorsHelper

  def show
    @product = Spree::Product.find(params[:id])
    @category = @product.taxons.first # 商品に関連するカテゴリを取得
    @ancestors = get_ancestors(@category)
  end
end
