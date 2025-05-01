class ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])
    @category = @product.taxons.first
    @ancestors = get_ancestors(@category)
    @related_products = @product.related_products.limit(4)
  end
end
