class HomeController < ApplicationController
  def index; end

  before_action :home_category_link

  def home_category_link
    names = ["Clothing", "Caps", "Bags", "Mugs"]
    parent = Spree::Taxon.find_by(name: "Categories")
    taxons = Spree::Taxon.where(parent_id: parent.id, name: names).index_by(&:name)
  
    @clothing = taxons["Clothing"]
    @caps = taxons["Caps"]
    @bags = taxons["Bags"]
    @mugs = taxons["Mugs"]
  end  
end
