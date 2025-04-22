module AncestorsHelper
  def get_ancestors(taxon)
    ancestors = []

    # 現在のタクソンを親タクソンがない最上位タクソンまでたどる(「このカテゴリは、どんな上位カテゴリに属してるの？」を調べるためのコードです。)
    while taxon.parent_id.present?
      # unshift を使うことで「上から順に（親 → 子）」並べることができます。
      ancestors.unshift(taxon)
      taxon = Spree::Taxon.find(taxon.parent_id)
    end

    ancestors = ancestors.reject { |a| a.parent_id.nil? }
    ancestors
  end
end
