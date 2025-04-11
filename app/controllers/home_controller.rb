class HomeController < ApplicationController
  def index
    image_map = {
      'Clothing' => 'cloth.jpg',
      'Caps' => 'cap.jpg',
      'Bags' => 'bag.jpg',
      'Mugs' => 'tableware.jpg',
    }

    @categories = Spree::Taxon.where(name: image_map.keys).map do |taxon|
      {
        id: taxon.id,
        name: taxon.name,
        image: "home/category/#{image_map[taxon.name]}",
      }
    end
  end
end
