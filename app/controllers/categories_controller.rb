class CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    @taxonomies = Spree::Taxonomy.includes(:root)
    @taxon_products = @taxon.products
    @products = Spree::Product.includes(master: [:default_price, images: [attachment_attachment: [:blob]]]).in_taxons(@taxon.name)
    @parent_taxons = @taxon.ancestors

    add_breadcrumb 'Home', :root_path
    add_breadcrumb @taxon.name, category_path(@taxon)  
  end
end
