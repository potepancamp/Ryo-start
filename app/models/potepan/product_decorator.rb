module Potepan
  module ProductDecorator
    RELATED_PRODUCTS_MAXIMUM_COUNT = 4

    def related_products
      taxons = self.taxons
      related = Spree::Product.
        joins(:taxons).
        where(taxons: { id: taxons.pluck(:id) }).
        where.not(id: id).
        distinct

      related.limit(RELATED_PRODUCTS_MAXIMUM_COUNT)
    end
  end
end

Spree::Product.include Potepan::ProductDecorator
