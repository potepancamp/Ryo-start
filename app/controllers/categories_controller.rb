class CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    @products = Spree::Product.includes(master: [:images, :default_price]).in_taxon(@taxon)
    @breadcrumb_taxons = @taxon.self_and_ancestors
  end
end
