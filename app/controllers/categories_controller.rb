class CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    @products = Spree::Product.includes(master: [:images, :default_price]).in_taxon(@taxon)
    @breadcrumbs = [{ name: 'ホーム', path: root_path }]
    unless [1, 2].include?(@taxon.id)
      @breadcrumbs << { name: @taxon.name, path: category_path(@taxon.id) }
    end
  end
end
