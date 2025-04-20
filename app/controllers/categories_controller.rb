class CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:taxon_id])
    @products = Spree::Product.includes(master: [:images, :default_price]).in_taxon(@taxon)

    @breadcrumbs = build_breadcrumbs(@taxon)
  end

  private

  def build_breadcrumbs(taxon)
    breadcrumbs = [{ name: 'ホーム', path: root_path }]

    taxon.
      self_and_ancestors.
      where.not(name: %w(Categories Brand)).
      each do |t|
        breadcrumbs << { name: t.name, path: category_path(t.id) }
      end

    breadcrumbs
  end
end
