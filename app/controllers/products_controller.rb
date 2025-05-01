class ProductsController < ApplicationController
  RELATED_PRODUCTS_MAXIMUM_COUNT = 4

  def show
    @product = Spree::Product.find(params[:id])
    @category = @product.taxons.first
    @ancestors = get_ancestors(@category)
    @related_products = @product.related_products.limit(RELATED_PRODUCTS_MAXIMUM_COUNT)
  end
end
