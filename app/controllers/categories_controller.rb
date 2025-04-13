class CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    @products = Spree::Product.includes(master: [:images, :default_price]).in_taxon(@taxon)
    @breadcrumbs = [{ name: 'ホーム', path: root_path }]
    @breadcrumbs << { name: @taxon.name, path: category_path(@taxon.id) } unless skip_breadcrumb?(@taxon)
  end

  private

  def skip_breadcrumb?(taxon)
    special_category_names = %w(Categories Brand)
    special_category_names.include?(taxon.name)
  end
end
