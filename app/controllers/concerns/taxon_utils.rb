module TaxonUtils
  extend ActiveSupport::Concern

  def get_ancestors(taxon)
    ancestors = []

    while taxon.parent_id.present?
      ancestors.unshift(taxon)
      taxon = Spree::Taxon.find(taxon.parent_id)
    end

    ancestors.reject { |a| a.parent_id.nil? }
  end
end
