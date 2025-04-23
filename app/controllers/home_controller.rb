class HomeController < ApplicationController
  def index
    @categories = Spree::Taxon.where(name: CATEGORY_IMAGE_MAP.keys).map do |taxon|
      {
        id: taxon.id,
        name: taxon.name,
        image: "home/category/#{CATEGORY_IMAGE_MAP[taxon.name]}",
      }
    end
  end
end
