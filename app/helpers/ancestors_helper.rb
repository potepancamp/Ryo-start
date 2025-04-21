module AncestorsHelper
  def get_ancestors(taxon)
    ancestors = []

    # 現在のタクソンを親タクソンがない最上位タクソンまでたどる
    while taxon.parent_id.present?
      ancestors.unshift(taxon)
      taxon = Spree::Taxon.find(taxon.parent_id)
    end

    ancestors
  end
end
