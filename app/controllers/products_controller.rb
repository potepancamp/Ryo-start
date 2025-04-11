class ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])
    @breadcrumbs = [
      { name: 'ホーム', path: root_path },
      { name: @product.taxons.first.parent.name, path: category_path(@product.taxons.first.parent.id) },
      { name: @product.taxons.first.name, path: category_path(@product.taxons.first.id) },
      { name: @product.name },
    ]
  end
end
