module Potepan
  module ProductDecorator
    def related_products
      Spree::Product.
        in_taxons(*taxons).
        where.not(id: id).
        distinct
    end
  end
end

Spree::Product.include Potepan::ProductDecorator
