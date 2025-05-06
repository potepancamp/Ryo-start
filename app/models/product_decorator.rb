module ProductDecorator
  def related_products
    Spree::Product.
      in_taxons(*taxons).
      where.not(id: id).
      order(:id)
  end
end

Spree::Product.include ProductDecorator
